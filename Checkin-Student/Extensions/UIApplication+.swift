//
//  UIApplication+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 4/10/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UIApplication {
    static func topViewController(controller: UIViewController? = shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.topViewController)
        }
        return controller
    }
}
