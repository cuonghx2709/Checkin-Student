//
//  APIUrls.swift
//  MovieDB
//
//  Created by cuonghx on 6/2/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension API {
    enum Urls {
        private static var apiBaseURL = "http://192.168.100.3:5050"
        static let loginAPI = apiBaseURL + "/login"
        static let forgotPwAPI = apiBaseURL + "/student/forgotpassword"
        static let student = apiBaseURL + "/student"
        static let enroll = apiBaseURL + "/enroll"
        static let unroll = apiBaseURL + "/unroll"
        static let course = apiBaseURL + "/course"
        static let checkin = apiBaseURL + "/check_in"
        static let message = apiBaseURL + "/message"
    }
}
