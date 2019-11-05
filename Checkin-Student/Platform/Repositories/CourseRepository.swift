//
//  CourseRepository.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/3/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol CourseRepositoryType {
    func getMyCourse(studentId: Int) -> Observable<[Course]>
    func unrollCourse(courseId: Int) -> Observable<Bool>
}

struct CourseRepository: CourseRepositoryType {
    func getMyCourse(studentId: Int) -> Observable<[Course]> {
        let input = API.MyCourseInput(studentId: studentId)
        return API.shared.myCourses(input)
    }
    
    func unrollCourse(courseId: Int) -> Observable<Bool> {
        return Observable.just(true)
    }
}
