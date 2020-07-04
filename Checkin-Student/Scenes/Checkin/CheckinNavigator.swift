//
//  CheckinNavigator.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Toaster

protocol CheckinNavigatorType {
    func showToastCheckinSuccess()
}

struct CheckinNavigator: CheckinNavigatorType {
    let assembler: Assembler
    let navigation: UINavigationController
    
    func showToastCheckinSuccess() {
        navigation.popViewController(animated: true)
        Toast(text: Constants.Messages.checkinSuccess).show()
    }
}
