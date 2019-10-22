//
//  LoginViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, BindableType {
    
    var viewModel: LoginViewModel!
    
    deinit {
        logDeinit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
    }
}

extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.login
}
