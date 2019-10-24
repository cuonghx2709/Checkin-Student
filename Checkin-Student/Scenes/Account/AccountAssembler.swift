//
//  AccountAssembler.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

protocol AccountAssembler {
    func resolve(navController: UINavigationController) -> AccountViewController
    func resolve(navController: UINavigationController) -> AccountViewModel
    func resolve(navController: UINavigationController) -> AccountNavigatorType
    func resolve() -> AccountUseCaseType
}

extension AccountAssembler {
    func resolve(navController: UINavigationController) -> AccountViewController {
        let vc = AccountViewController.instantiate()
        let vm: AccountViewModel = resolve(navController: navController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navController: UINavigationController) -> AccountViewModel {
        return AccountViewModel(navigator: resolve(navController: navController),
                                usecase: resolve())
    }
}

extension AccountAssembler where Self: DefaultAssembler {
    func resolve(navController: UINavigationController) -> AccountNavigatorType {
        return AccountNavigator(assembler: self, navigation: navController)
    }
    
    func resolve() -> AccountUseCaseType {
        return AccountUseCase()
    }
}

