//
//  API+Courses.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/3/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func myCourses(_ input: MyCourseInput) -> Observable<[Course]> {
        return request(input)
    }
    
    func getCourseByCode(_ input: GetCourseByCodeInput) -> Observable<Course> {
        return request(input)
    }
    
    func enrollCourse(_ input: EnrolCourseInput) -> Observable<APIOutput> {
        return request(input)
    }
    
    func unrollCourse(_ input: UnrollCourseInput) -> Observable<APIOutput> {
        return request(input)
    }
}

extension API {
    final class MyCourseInput: APIInput {
        init(studentId: Int) {
            let url = String(format: "\(Urls.enroll)/%d", studentId)
            super.init(urlString: url,
                       parameters: [:],
                       requestType: .get,
                       requireAccessToken: false)
        }
    }
    
    final class MyCourseOutput: APIOutput {
        
        private(set) var courses = [Course]()
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            courses <- map[""]
        }
    }
    
    final class GetCourseByCodeInput: APIInput {
        init(code: String) {
            let url = String(format: "%@/code/%@", Urls.course, code)
            super.init(urlString: url,
                       parameters: [:],
                       requestType: .get,
                       requireAccessToken: false)
        }
    }
    
    final class GetCourseByCodeOutput: APIOutput {
        private(set) var data: Course?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            data <- map[""]
        }
    }
    
    final class EnrolCourseInput: APIInput {
        init(courseId: Int, studentId: Int) {
            let params: [String: Any] = [
                "student_id": studentId,
                "course_id": courseId
            ]
            super.init(urlString: Urls.enroll,
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
    
    final class UnrollCourseInput: APIInput {
           init(courseId: Int, studentId: Int) {
               let params: [String: Any] = [
                   "student_id": studentId,
                   "course_id": courseId
               ]
               super.init(urlString: Urls.unroll,
                          parameters: params,
                          requestType: .post,
                          requireAccessToken: false)
           }
       }
    
}
