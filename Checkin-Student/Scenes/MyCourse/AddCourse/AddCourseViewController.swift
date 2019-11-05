//
//  AddCourseViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/5/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit
import KUIPopOver

final class AddCourseViewController: UIViewController, KUIPopOverUsable {
    
    var contentSize: CGSize {
        return CGSize(width: 500, height: 500)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .popover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constants.Title.addCourse
    }
}

extension AddCourseViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.popup
}
