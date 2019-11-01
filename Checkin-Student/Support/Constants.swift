//
//  Constants.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import SwiftKeychainWrapper

let keyChain = KeychainWrapper.standard

enum Constants {
    static let appName = "MovieDB"
    static let currentUserKey = "cuonghx.Checkin-Student.currentUser"
    
    enum Colors {
        static let tintColorOfApp = UIColor(hex: "3DCEC1")
    }
    
    enum StatusCode {
        static let successCode = 1
        static let failCode = -1
    }
    
    enum Messages {
        static let enterEmail = "Hãy nhập 1 email đúng định dạng"
        static let plzCheckEmail = "Hãy kiểm tra email của bạn"
        static let tryLater = "Đã có một số lỗi sảy ra! Hãy thử lại."
        static let notFoundEmail = "Không thể tìm thấy email của bạn! Vui lòng nhập đúng email."
    }
}
