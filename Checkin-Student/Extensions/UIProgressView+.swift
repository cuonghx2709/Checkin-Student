//
//  UIProgressView+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/7/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UIProgressView {
    func setProgressCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
        if let subLayer = layer.sublayers?[1] {
            subLayer.cornerRadius = radius
        }
        subviews[1].clipsToBounds = true
    }
}
