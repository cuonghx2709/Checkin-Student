//
//  UIAlertController+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/4/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UIAlertController {
    func set(vc: UIViewController?) {
        guard let vc = vc else { return }
        setValue(vc, forKey: "contentViewController")
    }
    
    func addAction(title: String,
                   style: UIAlertAction.Style = .default,
                   isEnabled: Bool = true,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
    }
    
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(self, animated: animated, completion: completion)
        }
    }
}
