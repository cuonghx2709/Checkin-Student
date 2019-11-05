//
//  MainViewController.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ESTabBarController_swift

final class MainViewController: ESTabBarController, BindableType {
    
    // MARK: - Propeties
    var viewModel: MainViewModel!
    private let checkinTrigger = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    func bindViewModel() {
        let input = MainViewModel.Input(
            checkinTrigger: checkinTrigger.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input)
        
        output.redirect
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    private func configView() {
        didHijackHandler = { [unowned self] tabbarController, viewController, index in
            self.checkinTrigger.onNext(())
        }
    }
    
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
