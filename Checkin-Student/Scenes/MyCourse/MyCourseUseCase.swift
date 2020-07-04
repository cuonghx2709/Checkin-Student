//
//  MyCourseUseCase.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol MyCourseUseCaseType {
    func myCourses(studentId: Int) -> Observable<[Course]>
    func getStudent() -> Observable<Student>
    func getTotalCourse(courses: [Course]) -> String
    func getName(student: Student)  -> String
    func unrollCourse(courseId: Int, studentId: Int) -> Observable<Void>
    func unrollCourse(courseUnrolled: Course, courses: [Course]) -> [Course]
    func enrollCourse(courseId: Int, studentId: Int) -> Observable<Void>
    func enrollCourse(courseEnrolled: Course, courses: [Course]) -> [Course]
}

struct MyCourseUseCase: MyCourseUseCaseType {
    
    let courseRepo: CourseRepositoryType
    let userRepo: UserRepositoryType
    
    func myCourses(studentId: Int) -> Observable<[Course]> {
        return courseRepo.getMyCourse(studentId: studentId)
    }
    
    func getStudent() -> Observable<Student> {
        return userRepo.getUser()
    }
    
    func getTotalCourse(courses: [Course]) -> String {
        return String(format: "%d courses", courses.count)
    }
    
    func getName(student: Student) -> String {
        guard !student.name.isEmpty else {
            return Constants.Title.defaulYourName
        }
        return student.name
    }
    
    func unrollCourse(courseId: Int, studentId: Int) -> Observable<Void> {
        return courseRepo.unrollCourse(courseId: courseId, studentId: studentId)
    }
    
    func unrollCourse(courseUnrolled: Course, courses: [Course]) -> [Course] {
        return courses.filter { $0.id != courseUnrolled.id }
    }
    
    func enrollCourse(courseId: Int, studentId: Int) -> Observable<Void> {
        return courseRepo.enrollCourse(courseId: courseId, studentId: studentId)
    }
    
    func enrollCourse(courseEnrolled: Course, courses: [Course]) -> [Course] {
        let constainsCourse = courses.contains { $0.id == courseEnrolled.id }
        guard !constainsCourse else {
            return courses
        }
        var courseCopy = courses
        courseCopy.append(courseEnrolled)
        return courseCopy
    }
}
