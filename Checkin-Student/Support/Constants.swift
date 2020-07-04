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
    static let keyNotificationAddCourse = "cuonghx.Checkin-Student.addCourse"
    
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
        static let loading = "Loading..."
        static let unrollSuccess = "Thoát khỏi khoá học thành công"
        static let unrollFail = "Thoát khỏi khoá học thất bại"
        static let enterEmailAndPassword = "Hãy nhập email và password để tiếp tục."
        static let createAccountMessage = "Bạn muốn tạo mới tài khoản ?"
        static let createAccountEmail = "Với email: %@"
        static let checkinSuccess = "Bạn đã checkin thành công!"
        static let updateSuccess = "Cập nhật thông tin thành công!"
        static let wrongimage = "Ảnh không hợp lệ vui lòng chọn ảnh khác!"
    }
    
    enum Title {
        static let defaulYourName = "Bạn, hãy cập nhật thông tin!"
        static let unroll = "Thoát khỏi khoá học"
        static let chat = "Chat Box"
        static let cancel = "Huỷ"
        static let yes = "Yes"
        static let addCourse = "Thêm khoá học mới"
        static let myAccount = "Tài khoản của tôi"
        static let update = "Cập nhật"
        static let logout = "Đăng xuất"
    }
}
