//
//  MyCourseViewModel.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct MyCourseViewModel {
    let navigator: MyCourseNavigatorType
    let usecase: MyCourseUseCaseType
}

extension MyCourseViewModel: ViewModelType {
    struct Input {
        var loadTrigger: Driver<Void>
        var refreshTrigger: Driver<Void>
        var checkinTrigger: Driver<Void>
        var myAccountTrigger: Driver<Void>
        var addCourseTrigger: Driver<Void>
        var menuCourse: Driver<IndexPath>
    }
    
    struct Output {
        var user: Driver<Void>
        var courses: Driver<[Course]>
        var totalCourse: Driver<String>
        var redirected: Driver<Void>
        var name: Driver<String>
        var error: Driver<Error>
        var isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        let loadingActivity = ActivityIndicator()
        
        let loadTrigger = Driver.merge(input.loadTrigger,
                                       input.refreshTrigger)
        
        let removeCourse = PublishSubject<Course>()
        
        let student = input.loadTrigger
            .flatMapLatest { _ in
                self.usecase.getStudent()
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let myCourses = loadTrigger
            .withLatestFrom(student)
            .flatMapLatest {
                self.usecase.myCourses(studentId: $0.id)
                    .trackError(errorTracker)
                    .trackActivity(loadingActivity)
                    .asDriverOnErrorJustComplete()
            }
        
        let totalCourse = myCourses
            .map { self.usecase.getTotalCourse(courses: $0) }
        
        let name = loadTrigger
            .withLatestFrom(student)
            .map { self.usecase.getName(student: $0) }
        
        let courses = Driver.merge(
            myCourses,
            removeCourse.asDriverOnErrorJustComplete()
                .withLatestFrom(myCourses) {
                    self.usecase.unrollCourse(courseUnrolled: $0, courses: $1)
            }
        )
        
        let menuCourse = input.menuCourse
            .withLatestFrom(courses) { $1[$0.row] }
            .flatMapLatest { course in
                self.navigator.showSheetAction(course: course)
                    .do(onNext: { action in
                        if action == .Chat {
                            self.navigator.showChatScreen(course: course)
                        }
                    })
                    .flatMapLatest { action  -> Observable<Void> in
                        switch action {
                        case .Unroll:
                            return self.navigator.confirmUnroll(course: course)
                                .filter { $0 }
                                .flatMapLatest { _ in
                                    self.usecase.unrollCourse(course: course)
                                        .trackError(errorTracker)
                                        .trackActivity(loadingActivity)
                                        .do(onNext: {
                                            self.navigator.showResultUnroll(isSuccess: $0)
                                            if $0 { removeCourse.onNext(course) }
                                        })
                                }
                                .mapToVoid()
                        default:
                            return .empty()
                        }
                    }
                    .asDriverOnErrorJustComplete()
            }
        
        let toMyAccount = input.myAccountTrigger
            .do(onNext: { _ in
                self.navigator.toMyAccount()
            })
        
        let checkin = input.checkinTrigger
            .do(onNext: { _ in
                self.navigator.toCheckinScreen()
            })
        
        let addCourese = input.addCourseTrigger
            .do(onNext: { _ in
                self.navigator.showAddCoursePopup()
        })
        
        let redirected = Driver.merge(toMyAccount, checkin, menuCourse, addCourese)
        
        return Output(user: student.mapToVoid(),
                      courses: courses,
                      totalCourse: totalCourse,
                      redirected: redirected,
                      name: name,
                      error: errorTracker.asDriver(),
                      isLoading: loadingActivity.asDriver()
        )
    }
}
