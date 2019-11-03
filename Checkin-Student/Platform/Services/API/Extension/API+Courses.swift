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
}
