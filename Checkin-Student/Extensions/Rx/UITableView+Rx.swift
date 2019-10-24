//
//  UITableView+Rx.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/8/19.
//  Copyright © 2019 Sun*. All rights reserved.
//
extension Reactive where Base: UITableView {
    func emptyData() -> Binder<Bool> {
        return Binder(base) { tableView, isEmptyData in
            if isEmptyData {
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: tableView.width,
                                   height: tableView.height)
                let emptyView = EmptyDataView()
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
}
