//
//  LoginViewModel.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

struct LoginViewModel {
    let usecase: LoginUseCaseType
    let navigator: LoginNavigatorType
}

extension LoginViewModel: ViewModelType {
    struct Input {
        let emailText: Driver<String>
        let passwordText: Driver<String>
        let loginTrigger: Driver<Void>
        let registerTrigger: Driver<Void>
        let forgotTrigger: Driver<Void>
    }
    
    struct Output {
        let validatedEmail: Driver<Bool>
        let logined: Driver<Void>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let validated: Driver<Bool>
        let signUp: Driver<Void>
        let forgotPW: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let emailValidate = validate(object: input.emailText,
                                     trigger: input.emailText.mapToVoid(),
                                     validator: self.usecase.validate(email:))
            .map { $0.isValid }
        
        let passwordValidate = validate(object: input.passwordText,
                                        trigger: input.passwordText.mapToVoid(),
                                        validator: self.usecase.validate(password:))
            .map { $0.isValid }
        
        let validated = Driver.combineLatest(emailValidate, passwordValidate)
            .map { $0 && $1 }
        
        let login = input.loginTrigger
            .withLatestFrom(Driver.combineLatest(input.emailText, input.passwordText))
            .flatMapLatest {
                self.usecase.login(email: $0.0, password: $0.1)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: {
                AuthManager.shared.setAuthStudent($0)
            })
            .do(onNext: {  _ in
                self.navigator.toMain()
            })
            .mapToVoid()
        
        let signUp = input.registerTrigger.withLatestFrom(validated)
            .do(onNext: {
                if !$0 {
                    self.navigator.showMessageInput()
                }
            })
            .filter { $0 }
            .withLatestFrom(input.emailText)
            .flatMapLatest {
                self.navigator.showConfirmSignUp(email: $0)
                    .asDriverOnErrorJustComplete()
            }
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(input.emailText, input.passwordText))
            .flatMapLatest {
                self.usecase.createAccountWith(email: $0.0, password: $0.1)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: {
                AuthManager.shared.setAuthStudent($0)
            })
            .do(onNext: {  _ in
                self.navigator.toMain()
            })
            .mapToVoid()
        
        let forgotPW = input.forgotTrigger
            .withLatestFrom(Driver.combineLatest(emailValidate, input.emailText))
            .do(onNext: {
                guard !$0.0 || $0.1.isEmpty else { return }
                self.navigator.showDialogErrorForgotPW()
            })
            .filter{ $0.0 && !$0.1.isEmpty }
            .map { $0.1 }
            .flatMapLatest { 
                self.usecase.forgotPW(email: $0)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: {
                self.navigator.showToastForgotPW(isSuccess: $0)
            })
            .mapToVoid()
        
        return Output(
            validatedEmail: emailValidate,
            logined: login,
            error: errorTracker.asDriver(),
            isLoading: activityTracker.asDriver(),
            validated: validated.asDriver(),
            signUp: signUp.asDriver(),
            forgotPW: forgotPW.asDriver()
        )
    }
}
