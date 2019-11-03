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
}
