//
//  API+Register.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/3/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func register(_ input: RegisterInput) -> Observable<RegisterOutput> {
        return request(input)
    }
}

extension API {
    final class RegisterInput: APIInput {
        init(email: String, password: String) {
            let params: [String: Any] = [
                "email": email,
                "password": password
            ]
            super.init(urlString: Urls.student,
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
    
    final class RegisterOutput: APIOutput {
        
        private(set) var studentId = 0
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            studentId <- map["student_id"]
        }
    }
}
