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
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lineLabel: UIView!
    
    var contentSize: CGSize {
        return CGSize(width: 300, height: 180)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .popover
        bindViewModel()
        
    }
    
    private func bindViewModel() {
        let errorTracker = ErrorTracker()
        
        continueButton.rx.tap
            .asDriver()
            .withLatestFrom(codeTextField.rx.text.orEmpty.asDriver())
            .flatMapLatest { code -> Driver<Course> in
                let input = API.GetCourseByCodeInput(code: code)
                return API.shared
                    .getCourseByCode(input)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .drive(tapContinueButtonBinder)
            .disposed(by: rx.disposeBag)
        
        errorTracker.asDriver().drive(rx.error).disposed(by: rx.disposeBag)
        codeTextField.rx.text
            .orEmpty
            .asDriverOnErrorJustComplete()
            .map { $0.isEmpty }
            .drive(codeisEmpty)
            .disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constants.Title.addCourse
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.Title.cancel,
            style: .plain,
            target: self,
            action: #selector(rightBarBtnHandler))
    }
    
    @objc private func rightBarBtnHandler() {
        dismissPopover(animated: true)
    }
}

extension AddCourseViewController {
    
    var codeisEmpty: Binder<Bool> {
        return Binder(self) { vc, isEmpty in
            vc.continueButton.alpha = isEmpty ? 0.5 : 1
            vc.continueButton.isEnabled = !isEmpty
        }
    }
 
    var tapContinueButtonBinder: Binder<Course> {
        return Binder(self) { vc, course in
            guard course.id != 0 else {
                vc.do {
                    $0.messageLabel.isHidden = false
                    $0.messageLabel.alpha = 1
                    $0.lineLabel.backgroundColor = .red
                }
                return
            }
            vc.do {
                $0.messageLabel.isHidden = true
                $0.messageLabel.alpha = 0
                $0.lineLabel.backgroundColor = Constants.Colors.tintColorOfApp
            }
            
            let confirmVC = ConfirmAddCourseViewController.instantiate()
            confirmVC.bindViewModel(course)
            vc.navigationController?.pushViewController(confirmVC, animated: true)
        }
    }
}

extension AddCourseViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.popup
}
