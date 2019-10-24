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
        
    }
    
    private func configView() {
        
    }
    
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
