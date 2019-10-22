//
//  CheckinViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class CheckinViewController: UIViewController, BindableType {
    
    var viewModel: CheckinViewModel!
    
    deinit {
        logDeinit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
    }

}

extension CheckinViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
