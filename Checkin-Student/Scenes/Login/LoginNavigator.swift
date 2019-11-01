//
//  LoginNavigator.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Toaster

protocol LoginNavigatorType {
    func showDialogErrorForgotPW()
    func showToastForgotPW(isSuccess: Bool)
    func toMain()
    func toSignUpScreen()
}

struct LoginNavigator: LoginNavigatorType {
    var assembler: Assembler
    var navigation: UINavigationController
    
    func showDialogErrorForgotPW() {
        navigation.showError(message: Constants.Messages.enterEmail)
    }
    
    func showToastForgotPW(isSuccess: Bool) {
        let message = isSuccess ? Constants.Messages.plzCheckEmail : Constants.Messages.notFoundEmail
        Toast(text: message).show()
    }
    
    func toMain() {
        // Code somthing to go to Main Screen
    }
    
    func toSignUpScreen() {
        // Code somthing to go to Sign up Screen
    }
}
