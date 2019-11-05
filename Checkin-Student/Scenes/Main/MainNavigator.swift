//
//  MainNavigator.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

protocol MainNavigatorType {
    func toCheckin()
}

struct MainNavigator: MainNavigatorType {
    var assembler: Assembler
    var navigation: UINavigationController
    
    func toCheckin() {
        let checkinVC: CheckinViewController = assembler.resolve(navController: navigation)
        navigation.pushViewController(checkinVC, animated: true)
    }
}
