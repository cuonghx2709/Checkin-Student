//
//  UIViewController+Rx.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/7/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import MBProgressHUD

extension Reactive where Base: UIViewController {
    var error: Binder<Error> {
        return Binder(base) { vc, error in
            vc.showError(message: error.localizedDescription)
        }
    }
    
    var validationBinder: Binder<ValidationResult> {
        return Binder(base) { vc, result in
            switch result {
            case .valid:
                break
            case let .invalid(errors):
                vc.showError(message: errors.map { $0.localizedDescription }.joined(separator: "\n"))
            }
        }
    }
    
    var isLoading: Binder<Bool> {
        return Binder(base) { vc, isLoading in
            if isLoading {
                let hud = MBProgressHUD.showAdded(to: vc.view, animated: true).then {
                    $0.customView = UIImageView(image: #imageLiteral(resourceName: "f-loading"))
                    $0.mode = .customView
                    $0.removeFromSuperViewOnHide = false
                    $0.isSquare = true
                    $0.label.text = ""
                    $0.bezelView.backgroundColor = .clear
                    $0.contentColor = .clear
                }
                let animation = CABasicAnimation(keyPath: "transform.rotation").then {
                    $0.fromValue = 0.0
                    $0.toValue = 2.0 * Double.pi
                    $0.duration = 1
                    $0.repeatCount = HUGE
                    $0.isRemovedOnCompletion = false
                }
                hud.customView?.layer.add(animation, forKey: "rotationAnimation")
            } else {
                MBProgressHUD.hide(for: vc.view, animated: true)
            }
        }
    }
}

extension Reactive where Base: UIViewController {
    var viewWillAppearTrigger: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    var viewDidAppearTrigger: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    var viewWillDisappearTrigger: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    var viewDidDisappearTrigger: Driver<Void> {
        return sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    var viewOneTimeAppearTrigger: Driver<Void> {
        let isAppear = BehaviorRelay(value: false)
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .withLatestFrom(isAppear)
            .filter { !$0 }
            .do(onNext: { _ in
                isAppear.accept(true)
            })
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
}
