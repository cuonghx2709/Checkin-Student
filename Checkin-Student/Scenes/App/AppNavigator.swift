//
//  AppNavigator.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toMain() {
        let nav = UINavigationController()
        let rootVC: UIViewController
        if AuthManager.shared.isAuth {
            let loginedScreen: MainViewController = assembler.resolve(navController: nav)
            nav.viewControllers.append(loginedScreen)
        } else {
            let loginScreen: LoginViewController = assembler.resolve(navController: nav)
            nav.viewControllers.append(loginScreen)
        }
        window.rootViewController = nav
    }
}
