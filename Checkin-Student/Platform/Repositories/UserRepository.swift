//
//  UserRepository.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/30/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol UserRepositoryType {
    func login(email: String, password: String) -> Observable<Student>
    func forgotPW(email: String) -> Observable<Bool>
    func getUser() -> Observable<Student>
}

struct UserRepository: UserRepositoryType {
    func login(email: String, password: String) -> Observable<Student> {
        let input = API.LoginInput(email: email, password: password)
        return API.shared.login(input)
            .map { output in
                guard let data = output.student,
                    output.statusCode == Constants.StatusCode.successCode else {
                        throw WrongEmailOrPasswordError()
            }
            return data
        }
    }
    
    func forgotPW(email: String) -> Observable<Bool> {
        let input = API.ForgotPWInput(email: email)
        return API.shared.forgotPW(input)
            .map { $0.statusCode == Constants.StatusCode.successCode }
    }
    
    func getUser() -> Observable<Student> {
        guard let student = AuthManager.authStudent else {
            return .error(APIExpiredTokenError())
        }
        return Observable.just(student)
    }
}
