//
//  MyCourseCollectionViewCell.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/28/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import UIKit

final class MyCourseCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var bgimageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Course) {
        titleLabel.text = viewModel.name
        descriptionLabel.text = viewModel.place
    }
}
