//
// UIViewController+.swift
// fGoal
//
// Created by Phạm Xuân Tiến on 3/20/19.
// Copyright © 2019 Sun*. All rights reserved.
//

import MBProgressHUD

extension UIViewController {
    func showError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Lỗi!",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func removeBackButtonTitle() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)).do {
            $0.cancelsTouchesInView = false
            view.addGestureRecognizer($0)
        }
    }
    
    func isReTapOnTabBar(willSelectVC: UIViewController) -> Bool {
        return tabBarController?.selectedViewController == willSelectVC
    }
}
