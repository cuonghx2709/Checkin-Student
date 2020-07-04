//
//  CourseRepository.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/3/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol CourseRepositoryType {
    func getMyCourse(studentId: Int) -> Observable<[Course]>
    func unrollCourse(courseId: Int, studentId: Int) -> Observable<Void>
    func enrollCourse(courseId: Int, studentId: Int) -> Observable<Void>
}

struct CourseRepository: CourseRepositoryType {
    func getMyCourse(studentId: Int) -> Observable<[Course]> {
        let input = API.MyCourseInput(studentId: studentId)
        return API.shared.myCourses(input)
    }
    
    func unrollCourse(courseId: Int, studentId: Int) -> Observable<Void> {
        let input = API.UnrollCourseInput(courseId: courseId, studentId: studentId)
        return API.shared.unrollCourse(input)
            .map {
                guard $0.statusCode == Constants.StatusCode.successCode else {
                    throw UnrollFaile()
                }
            }
    }
    
    func enrollCourse(courseId: Int, studentId: Int) -> Observable<Void> {
        let input = API.EnrolCourseInput(courseId: courseId, studentId: studentId)
        return API.shared.enrollCourse(input)
            .map {
                guard $0.statusCode == Constants.StatusCode.successCode else {
                    throw CourseExisted()
                }
            }
    }
}
