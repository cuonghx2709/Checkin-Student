//
//  AnimationContentView.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/23/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation
import ESTabBarController_swift
import Lottie

final class AnimationContentView: AnimateBasicContentView {
    
    let lottieView: AnimationView! = {
        let lottieView = AnimationView(name: "face-scanning")
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit
        return lottieView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(lottieView)
        self.insets = UIEdgeInsets.init(top: -3, left: 0, bottom: 0, right: 0)
        self.superview?.bringSubviewToFront(self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        lottieView.frame = self.bounds.insetBy(dx: 0, dy: 0)
        lottieView.play()
        lottieView.backgroundBehavior = .pauseAndRestore
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        super.selectAnimation(animated: animated, completion: nil)
    }
    
    override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        super.deselectAnimation(animated: animated, completion: nil)
        lottieView.play()
    }

}
