//
//  AccountViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/23/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController, BindableType {
    
    var viewModel: AccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        
    }
}

extension AccountViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
