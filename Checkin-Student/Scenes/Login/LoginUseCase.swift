//
//  LoginUseCase.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol LoginUseCaseType {
    func validate(email: String) -> ValidationResult
    func validate(password: String) -> ValidationResult
    func login(email: String, password: String) -> Observable<Student>
    func forgotPW(email: String) -> Observable<Bool>
    func createAccountWith(email: String, password: String) -> Observable<Student>
}

struct LoginUseCase: LoginUseCaseType {
    
    var userRepo: UserRepositoryType
    
    func validate(email: String) -> ValidationResult {
        guard !email.isEmpty else { return ValidationResult.valid }
        let emailValidateRule = ValidationRulePattern(
            pattern: EmailValidationPattern.standard,
            error: ValidateEmailError()
        )
        return email.validate(rule: emailValidateRule)
    }
    
    func validate(password: String) -> ValidationResult {
        let rule = ValidationRuleLength(min: 1, error: ValidatePassword())
        return password.validate(rule: rule)
    }
    
    func login(email: String, password: String) -> Observable<Student> {
        return userRepo.login(email: email, password: password)
    }
    
    func forgotPW(email: String) -> Observable<Bool> {
        return userRepo.forgotPW(email: email)
    }
    
    func createAccountWith(email: String, password: String) -> Observable<Student> {
        return userRepo.signup(email: email, password: password)
    }
}
