//
//  UIView+Rx.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/7/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension Reactive where Base: UIView {
    var backgroundColor: Binder<UIColor?> {
        return Binder(base) { view, color in
            view.backgroundColor = color
        }
    }
    
    func tap() -> Observable<Void> {
        return tapGesture()
            .when(.recognized)
            .mapToVoid()
    }
}
