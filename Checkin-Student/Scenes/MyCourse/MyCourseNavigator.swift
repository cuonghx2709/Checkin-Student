//
//  MyCourseNavigator.swift
//  Checkin-Student
//
//  Created by Hoàng Xuân Cường on 10/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Toaster
import KUIPopOver

protocol MyCourseNavigatorType {
    func toMyAccount()
    func toCheckinScreen()
    func showSheetAction(course: Course) -> Observable<CourseAction>
    func confirmUnroll(course: Course) -> Observable<Bool>
    func showResultUnroll(isSuccess: Bool)
    func showChatScreen(course: Course)
    func showAddCoursePopup()
}

struct MyCourseNavigator: MyCourseNavigatorType {
    
    let assembler: Assembler
    let navigation: UINavigationController
    
    func toMyAccount() {
        guard let mainVC = navigation.viewControllers.first as? MainViewController else {
            return
        }
        mainVC.selectedIndex = 2
    }
    
    func toCheckinScreen() {
        let checkinVC: CheckinViewController = assembler.resolve(navController: navigation)
        checkinVC.modalTransitionStyle = .coverVertical
        checkinVC.modalPresentationStyle = .formSheet
        navigation.pushViewController(checkinVC, animated: true)
    }
    
    func showSheetAction(course: Course) -> Observable<CourseAction> {
        return Observable.create { obser in
            let alert = UIAlertController(title: "ABCd",
                                          message: "something",
                                          preferredStyle: .actionSheet)
                .then {
                    $0.addAction(title:  CourseAction.Cancel.description,
                                 style: .cancel)
                    $0.addAction(title: CourseAction.Chat.description) { _ in
                        obser.onNext(.Chat)
                    }
                    $0.addAction(title: CourseAction.Unroll.description) { _ in
                        obser.onNext(.Unroll)
                    }
                }
            self.navigation.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func confirmUnroll(course: Course) -> Observable<Bool> {
        return Observable.create { obser in
            let alert = UIAlertController(title: String(format: "Bạn có muốn thoát khỏi khoá học %@", course.name),
                                          message: nil,
                                          preferredStyle: .alert)
                .then {
                    $0.addAction(title:  Constants.Title.yes,
                                 style: .destructive) { _ in
                                    obser.onNext(true)
                    }
                    $0.addAction(title: Constants.Title.cancel,
                                 style: .cancel) { _ in
                                    obser.onNext(false)
                    }
            }
            self.navigation.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showResultUnroll(isSuccess: Bool) {
        let message = isSuccess ? Constants.Messages.unrollSuccess : Constants.Messages.unrollFail
        Toast(text: message).show()
    }
    
    func showChatScreen(course: Course)  {
        
    }
    
    func showAddCoursePopup() {
//        guard let topView = navigation.topMostViewController()?.view else { return }
//        let addCoursePopup = AddCourseViewController.instantiate()
//        addCoursePopup.showPopoverWithNavigationController(
//            sourceView: topView,
//            shouldDismissOnTap: false
//        )
    }
}

enum CourseAction {
    case Unroll
    case Chat
    case Cancel
    
    var description: String {
        switch self {
        case .Unroll:
            return Constants.Title.unroll
        case .Chat:
            return Constants.Title.chat
        case .Cancel:
            return Constants.Title.cancel
        }
    }
}
