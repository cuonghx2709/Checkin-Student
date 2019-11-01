//
//  API+ForgotPW.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func forgotPW(_ input: ForgotPWInput) -> Observable<ForgotPWOutput> {
        return request(input)
    }
}

extension API {
    final class ForgotPWInput: APIInput {
        init(email: String) {
            let params: [String: Any] = [
                "email": email
            ]
            super.init(urlString: Urls.forgotPwAPI,
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
    
    final class ForgotPWOutput: APIOutput {
        override func mapping(map: Map) {
            super.mapping(map: map)
        }
    }
}
