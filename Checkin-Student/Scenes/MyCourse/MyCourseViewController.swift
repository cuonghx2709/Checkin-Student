//
//  MyCourseViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class MyCourseViewController: UIViewController, BindableType {

    var viewModel: MyCourseViewModel!
    
    deinit {
        logDeinit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bindViewModel() {
        
    }
}

extension MyCourseViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
