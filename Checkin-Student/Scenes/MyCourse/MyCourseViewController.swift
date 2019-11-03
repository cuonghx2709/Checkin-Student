//
//  MyCourseViewController.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class MyCourseViewController: UIViewController, BindableType {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var totalCourseLabel: UILabel!
    @IBOutlet private weak var checkinTimeLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var checkinButton: UIButton!
    @IBOutlet private weak var myAccountButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Propeties
    
    var viewModel: MyCourseViewModel!
    
    private lazy var refreshControl: UIRefreshControl = {
        return UIRefreshControl().then {
            $0.attributedTitle = NSAttributedString(string: Constants.Messages.loading)
        }
    }()
    
    enum LayoutOptions {
        static let height: CGFloat = 200
    }
    
    // MARK: - Life Cycle
    
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

    // MARK: - Methods
    
    func bindViewModel() {
        let input = MyCourseViewModel.Input(
            loadTrigger: Driver.just(()),
            refreshTrigger: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            checkinTrigger: checkinButton.rx.tap.asDriver(),
            myAccountTrigger: myAccountButton.rx.tap.asDriver(),
            addCourseTrigger: addButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.user.drive().disposed(by: rx.disposeBag)
        
        output.courses
            .drive(collectionView.rx.items) { collectionView, row, course in
                let indexPath = IndexPath(row: row, section: 0)
                return collectionView
                    .dequeueReusableCell(for: indexPath,
                                         cellType: MyCourseCollectionViewCell.self)
                    .then {
                        $0.bindViewModel(course)
                    }
            }
            .disposed(by: rx.disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.totalCourse
            .drive(totalCourseLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        
        output.name
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
    }
    
    private func configView() {
        collectionView.register(cellType: MyCourseCollectionViewCell.self)
        collectionView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        scrollView.addSubview(refreshControl)
    }
}

extension MyCourseViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        return CGSize(width: view.width / 2 - 25 , height: LayoutOptions.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension MyCourseViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
