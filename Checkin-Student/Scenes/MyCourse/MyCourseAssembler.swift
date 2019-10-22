//
//  MyCourseAssembler.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol MyCourseAssembler {
    func resolve(navController: UINavigationController) -> MyCourseViewController
    func resolve(navController: UINavigationController) -> MyCourseViewModel
    func resolve(navController: UINavigationController) -> MyCourseNavigatorType
    func resolve() -> MyCourseUseCaseType
}

extension MyCourseAssembler {
    func resolve(navController: UINavigationController) -> MyCourseViewController {
        let vc = MyCourseViewController.instantiate()
        let vm: MyCourseViewModel = resolve(navController: navController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navController: UINavigationController) -> MyCourseViewModel {
        return MyCourseViewModel(navigator: resolve(navController: navController),
                                 usecase: resolve())
    }
}

extension MyCourseAssembler where Self: DefaultAssembler {
    func resolve(navController: UINavigationController) -> MyCourseNavigatorType {
        return MyCourseNavigator(assembler: self, navigation: navController)
    }
    
    func resolve() -> MyCourseUseCaseType {
        return MyCourseUseCase()
    }
}
