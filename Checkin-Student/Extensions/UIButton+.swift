//
//  UIButton+.swift
//  fGoal
//
//  Created by Hoàng Xuân Cường on 7/2/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UIButton {
    func leftImage(image: UIImage?) {
        guard let image = image else { return }
        setImage(image, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width)
    }
}
