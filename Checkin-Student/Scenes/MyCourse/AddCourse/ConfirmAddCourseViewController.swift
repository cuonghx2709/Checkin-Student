//
//  ConfirmAddCourseViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 11/7/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class ConfirmAddCourseViewController: UIViewController {
    
    private var course: Course!
    @IBOutlet private weak var courseNameLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        courseNameLabel.text = course.name
    }
    
    func bindViewModel(_ course: Course) {
        self.course = course
    }
    
    @IBAction func handlerContinueButton(_ sender: UIButton) {
        guard let course = self.course else {
            navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        let dataAttachment: [String: Any] = ["course": course]
        NotificationCenter.default.post(
            name: NSNotification.Name(Constants.keyNotificationAddCourse),
            object: nil,
            userInfo: dataAttachment)
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ConfirmAddCourseViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.popup
}
