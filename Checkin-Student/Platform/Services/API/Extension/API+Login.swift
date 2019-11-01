//
//  API+Login.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/30/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func login(_ input: LoginInput) -> Observable<LoginOutput> {
        return request(input)
    }
}

extension API {
    final class LoginInput: APIInput {
        init(email: String, password: String) {
            let params: [String: Any] = [
                "email" : email,
                "password": password
            ]
            super.init(urlString: Urls.loginAPI,
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
    
    final class LoginOutput: APIOutput {
        
        private(set) var student: Student?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            student <- map["student"]
        }
    }
}


