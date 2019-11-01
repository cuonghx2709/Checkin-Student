//
//  APIUrls.swift
//  MovieDB
//
//  Created by cuonghx on 6/2/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension API {
    enum Urls {
        private static var apiBaseURL = "http://128.199.145.205:5050"
        static let loginAPI = apiBaseURL + "/login"
        static let forgotPwAPI = apiBaseURL + "/student/forgotpassword"
    }
}
