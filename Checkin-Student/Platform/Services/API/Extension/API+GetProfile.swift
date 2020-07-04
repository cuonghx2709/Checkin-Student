//
//  API+GetProfile.swift
//  Checkin-Student
//
//  Created by cuong hoang on 5/18/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func getProfile(_ input: ProfileInput) -> Observable<ProfileOutput> {
        return request(input)
    }
    
    func updateProfile(_ input: UpdateProfileInput) -> Observable<APIOutput> {
        return request(input)
    }
}

extension API {
    final class ProfileInput: APIInput {
        init(id: Int) {
            super.init(urlString: String(format: "%@/%d", Urls.student, id),
                       parameters: [:],
                       requestType: .get,
                       requireAccessToken: false)
        }
    }
    
    final class ProfileOutput: APIOutput {
        
        private(set) var student: Student?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            student <- map["student"]
        }
    }
    
    final class UpdateProfileInput: APIInput {
        init(student: Student) {
            let params: [String: Any] = [
                "student_name": student.name,
                "birthday": student.birthDay,
                "vectors": student.vectors
            ]
            super.init(urlString: String(format: "%@/%d", Urls.student, student.id),
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
}

