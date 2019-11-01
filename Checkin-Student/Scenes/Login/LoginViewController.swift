//
//  LoginViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var errorEmailLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var errorLineView: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var forgotButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: LoginViewModel!
    
    // MARK: - Life Cycle
    
    deinit {
        logDeinit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Methods
    
    func bindViewModel() {
        let input = LoginViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty.asDriver(),
            passwordText: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTrigger: loginButton.rx.tap.asDriver(),
            registerTrigger: registerButton.rx.tap.asDriver(),
            forgotTrigger: forgotButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.validatedEmail
            .drive(emailValidatorBinder)
            .disposed(by: rx.disposeBag)
        
        output.validated
            .drive(validated)
            .disposed(by: rx.disposeBag)
        
        output.logined
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.forgotPW
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.signUp
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    private func configView() {
        
    }
}

extension LoginViewController {
    private var emailValidatorBinder: Binder<Bool> {
        return Binder(self) { vc, validate in
            vc.errorEmailLabel.isHidden = validate
            vc.errorLineView.backgroundColor = validate ? Constants.Colors.tintColorOfApp : .red
        }
    }
    
    private var validated: Binder<Bool> {
        return Binder(self) { vc, validated in
            let emailIsEmpty = vc.emailTextField.text?.isEmpty ?? true
            vc.loginButton.isEnabled = validated && !emailIsEmpty
            vc.loginButton.alpha = (validated && !emailIsEmpty ) ? 1 : 0.5
        }
    }
}

extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.login
}
