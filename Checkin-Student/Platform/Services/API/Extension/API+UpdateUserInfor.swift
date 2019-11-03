//
//  API+UpdateUserInfor.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/3/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    final class UpdateInforInput: APIInput {
        init(user: Student) {
            let params: [String: Any] = [
                "student_name": user.name,
                "birthday": user.birthDay,
                "vectors": user.vectors
            ]
            let url = String(format: "\(Urls.student)/%d", user.id)
            super.init(urlString: url,
                       parameters: params,
                       requestType: .post,
                       requireAccessToken: false)
        }
    }
}
