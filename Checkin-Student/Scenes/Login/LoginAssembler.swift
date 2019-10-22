//
//  LoginAssembler.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol LoginAssembler {
    func resolve(navController: UINavigationController) -> LoginViewController
    func resolve(navController: UINavigationController) -> LoginViewModel
    func resolve(navController: UINavigationController) -> LoginNavigatorType
    func resolve() -> LoginUseCaseType
}

extension LoginAssembler {
    func resolve(navController: UINavigationController) -> LoginViewController {
        let vc = LoginViewController.instantiate()
        let vm: LoginViewModel = resolve(navController: navController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navController: UINavigationController) -> LoginViewModel {
        return LoginViewModel(usecase: resolve(),
                              navigator: resolve(navController: navController))
    }
}

extension LoginAssembler where Self: DefaultAssembler {
    func resolve(navController: UINavigationController) -> LoginNavigatorType {
        return LoginNavigator(assembler: self, navigation: navController)
    }
    
    func resolve() -> LoginUseCaseType {
        return LoginUseCase()
    }
}
