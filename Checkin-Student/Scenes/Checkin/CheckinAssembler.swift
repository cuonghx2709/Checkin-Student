//
//  CheckinAssembler.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol CheckinAssembler {
    func resolve(navController: UINavigationController) -> CheckinViewController
    func resolve(navController: UINavigationController) -> CheckinViewModel
    func resolve(navController: UINavigationController) -> CheckinNavigatorType
    func resolve() -> CheckinUseCaseType
}

extension CheckinAssembler {
    func resolve(navController: UINavigationController) -> CheckinViewController {
        let vc = CheckinViewController.instantiate()
        let vm: CheckinViewModel = resolve(navController: navController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navController: UINavigationController) -> CheckinViewModel {
        return CheckinViewModel(usecase: resolve(),
                                navigator: resolve(navController: navController))
    }
}

extension CheckinAssembler where Self: DefaultAssembler {
    func resolve(navController: UINavigationController) -> CheckinNavigatorType {
        return CheckinNavigator(assembler: self, navigation: navController)
    }
    
    func resolve() -> CheckinUseCaseType {
        return CheckinUseCase(facenet: FaceNet(), repo: resolve())
    }
}
