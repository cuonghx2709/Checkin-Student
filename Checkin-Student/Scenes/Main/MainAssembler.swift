//
//  MainAssembler.swift
//  MovieDB
//
//  Created by cuonghx on 6/14/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation
import ESTabBarController_swift

protocol MainAssembler {
    func resolve(navController: UINavigationController) -> MainViewController
    func resolve(navController: UINavigationController) -> MainViewModel
    func resolve(navController: UINavigationController) -> MainNavigatorType
    func resolve() -> MainUseCaseType
}

extension MainAssembler where Self: DefaultAssembler {
    func resolve(navController: UINavigationController) -> MainNavigatorType {
        return MainNavigator(assembler: self,
                             navigation: navController)
    }
    
    func resolve() -> MainUseCaseType {
        return MainUseCase()
    }
    
    func resolve(navController: UINavigationController) -> MainViewController {
        let vc = MainViewController.instantiate()
        let vm: MainViewModel = resolve(navController: navController)
        vc.bindViewModel(to: vm)
        
        // 1: MycourseVC
        let mycourseVC: MyCourseViewController = resolve(navController: navController)
        mycourseVC.tabBarItem = ESTabBarItem(AnimateBasicContentView(),
                                             title: "My Courses",
                                             image: #imageLiteral(resourceName: "homeN"),
                                             selectedImage: #imageLiteral(resourceName: "homeHL"))
        
        // 3: CheckinVC
        let checkinVC: CheckinViewController = resolve(navController: navController)
        checkinVC.tabBarItem = ESTabBarItem(AnimationContentView())
        
        vc.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 1 {
                return true
            }
            return false
        }
        
        // 5: AccountVC
        let accountVC: AccountViewController = resolve(navController: navController)
        accountVC.tabBarItem = ESTabBarItem(AnimateBasicContentView(),
                                            title: "Account",
                                            image: #imageLiteral(resourceName: "accountN"),
                                            selectedImage: #imageLiteral(resourceName: "accountHL"))
        
        vc.viewControllers = [mycourseVC, checkinVC, accountVC]
        
        return vc
    }
    
    func resolve(navController: UINavigationController) -> MainViewModel {
        return MainViewModel(usecase: resolve(),
                             navigator: resolve(navController: navController))
    }
}
