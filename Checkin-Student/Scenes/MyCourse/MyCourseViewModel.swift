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
    }
    
    struct Output {
        var user: Driver<Void>
        var courses: Driver<[Course]>
        var totalCourse: Driver<String>
        var name: Driver<String>
        var error: Driver<Error>
        var isLoading: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        let loadingActivity = ActivityIndicator()
        
        let loadTrigger = Driver.merge(input.loadTrigger,
                                       input.refreshTrigger)
        
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
        
        let toMyAccount = input.myAccountTrigger
            .do(onNext: { _ in
                self.navigator.toMyAccount()
            }).drive()
        
        let name = loadTrigger
            .withLatestFrom(student)
            .map { self.usecase.getName(student: $0) }
        
        return Output(user: student.mapToVoid(),
                      courses: myCourses,
                      totalCourse: totalCourse,
                      name: name,
                      error: errorTracker.asDriver(),
                      isLoading: loadingActivity.asDriver()
        )
    }
}
