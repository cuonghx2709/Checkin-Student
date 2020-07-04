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
    func showConfirmSignUp(email: String) -> Observable<Bool>
    func showMessageInput()
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
        let mainVC: MainViewController = assembler.resolve(navController: navigation)
        mainVC.modalPresentationStyle = .fullScreen
        navigation.setViewControllers([mainVC], animated: true)
//        navigation.pushViewController(UINavigationController(rootViewController: mainVC), animated: true)
//        navigation.viewControllers = [UINavigationController(rootViewController: mainVC)]
//        navigation.present(UINavigationController(rootViewController: mainVC), animated: true, completion: nil)
    }
    
    func toSignUpScreen() {
        // Code somthing to go to Sign up Screen
        print("cuonghx")
    }
    
    func showConfirmSignUp(email: String) -> Observable<Bool> {
        return Observable.create { obser -> Disposable in
            let alert = UIAlertController(
                title: Constants.Messages.createAccountMessage,
                message: String(format: Constants.Messages.createAccountEmail,
                                email),
                preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                obser.onNext(true)
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
                obser.onNext(false)
            }
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            self.navigation.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showMessageInput() {
        navigation.showError(message: Constants.Messages.enterEmailAndPassword)
    }
}
