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
    func signup(email: String, password: String) -> Observable<Student>
    func updateUserInfor(student: Student) -> Observable<Void>
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
    
    func signup(email: String, password: String) -> Observable<Student> {
        let input = API.RegisterInput(email: email, password: password)
        return API.shared.register(input)
            .flatMapLatest { output -> Observable<Student> in
                if output.statusCode == Constants.StatusCode.failCode {
                    return .error(EmailExisted())
                }
                return self.getUser(id: output.studentId)
            }
    }
    
    func getUser(id: Int) -> Observable<Student> {
        let input = API.ProfileInput(id: id)
        return API.shared.getProfile(input)
            .map { output in
                guard let data = output.student else {
                    throw WrongConvert()
                }
                return data
            }
    }
    
    func updateUserInfor(student: Student) -> Observable<Void> {
        let input = API.UpdateProfileInput(student: student)
        return API.shared.updateProfile(input)
            .map { output -> Void in
                if output.statusCode != Constants.StatusCode.successCode {
                    throw UpdateFaile()
                }
            }
    }
}
