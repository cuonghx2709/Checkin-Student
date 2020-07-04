//
//  UIImage+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/24/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UIImage {
    func maskWith(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        color.setFill()
        draw(in: rect)
        context?.setBlendMode(.sourceIn)
        context?.fill(rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage ?? UIImage()
    }
    
    func resizeImage(newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: floor(newWidth),
                                           height: floor(newHeight)))
        self.draw(in: CGRect(x: 0,
                             y: 0,
                             width: newWidth,
                             height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension CIImage {
    func resizeImage(newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        return UIImage(ciImage: self).resizeImage(newWidth: newWidth,
                                                  newHeight: newHeight)
    }
}
