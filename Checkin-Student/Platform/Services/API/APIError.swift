//
//  APIError.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct APIExpiredTokenError: APIError {
    var errorDescription: String? {
        return NSLocalizedString("api.expiredTokenError",
                                 value: "Access token is expired",
                                 comment: "")
    }
}

struct APIResponseError: APIError {
    let statusCode: Int?
    let message: String
    
    var errorDescription: String? {
        return message
    }
}

struct WrongEmailOrPasswordError: APIError {
    var errorDescription: String? {
        return "Sai tài khoản hoặc mật khẩu"
    }
}

struct WrongConvert: APIError {
    var errorDescription: String? {
        return "Có lỗi không mong muốn đã sảy ra. Hãy liên hệ với nhà phát triển."
    }
}

struct EmailExisted: APIError {
    var errorDescription: String? {
        return "Email đã được đăng ký. Hãy xử dụng email khác."
    }
}

struct CourseExisted: APIError {
    var errorDescription: String? {
        return "Bạn đã enroll vào khoá học này rồi."
    }
}

struct UnrollFaile: APIError {
    var errorDescription: String? {
        return "Không thể unroll khỏi khoá học hãy thử lại sau."
    }
}

struct UpdateImageError: APIError {
    var errorDescription: String? {
        return "Hãy cập nhật ảnh của bạn trước khi tiếp tục."
    }
}

struct SomethingWrongCheckin: APIError {
    var errorDescription: String? {
        return "Đã xảy ra vấn đề ngoài ý muốn. Hãy cập nhật lại ảnh và thử lại."
    }
}

struct WrongCheckinWithCurrentLocation: APIError {
    var errorDescription: String? {
        return "Không thể checkin với vị trí hiện tại."
    }
}

struct AlreadyCheckin: APIError {
    var errorDescription: String? {
        return "Bạn đã checkin rồi."
    }
}

struct UpdateFaile: APIError {
    var errorDescription: String? {
        return "Không thể thực hiện cập nhật dữ liệu. Hãy thử lại sau."
    }
}
