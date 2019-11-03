//
//  MyCourseNavigator.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol MyCourseNavigatorType {
    func toMyAccount()
}

struct MyCourseNavigator: MyCourseNavigatorType {
    let assembler: Assembler
    let navigation: UINavigationController
    
    func toMyAccount() {
        guard let mainVC = navigation.viewControllers.first as? MainViewController else {
            return
        }
        mainVC.selectedIndex = 2
    }
}
