//
//  MyCourseViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class MyCourseViewController: UIViewController, BindableType {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var viewModel: MyCourseViewModel!
    
    deinit {
        logDeinit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        collectionViewHeight.constant = collectionView.contentSize.height
    }

    func bindViewModel() {
        
    }
    
    private func configView() {
        collectionView.register(cellType: MyCourseCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension MyCourseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCourseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width / 2 - 25 , height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension MyCourseViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
