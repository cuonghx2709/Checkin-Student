//
//  File.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Toaster

protocol AccountNavigatorType {
    func showToastUpdateSuccess()
    func showImageWrong()
}

struct AccountNavigator: AccountNavigatorType {
    let assembler: Assembler
    let navigation: UINavigationController
    
    func showToastUpdateSuccess() {
        Toast(text: Constants.Messages.updateSuccess).show()
    }
    
    func showImageWrong() {
        Toast(text: Constants.Messages.wrongimage).show()
    }
}
