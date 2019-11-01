//
//  AuthManager.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

final class AuthManager {
    static let shared = AuthManager()
    
    fileprivate static var _student: Student?
    static var authStudent: Student? {
        get {
            if _student != nil {
                return _student
            } else if let userJSONString = keyChain.string(forKey: Constants.currentUserKey) {
                _student = Student(JSONString: userJSONString)
            }
            return _student
        }
        set {
            if newValue == nil {
                keyChain.removeObject(forKey: Constants.currentUserKey)
            } else if let json = newValue?.toJSONString() {
                keyChain.set(json, forKey: Constants.currentUserKey)
            }
            _student = newValue
        }
    }
    var isAuth: Bool {
        return AuthManager.authStudent != nil ? true : false
    }
    
    func setAuthStudent(_ student: Student) {
        AuthManager.authStudent = student
    }
    
    func logOut() {
        AuthManager.authStudent = nil
    }
}

