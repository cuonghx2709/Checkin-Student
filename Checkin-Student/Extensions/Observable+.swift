//
//  Observable+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 3/20/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension SharedSequenceConvertibleType where E == Bool {
    public func not() -> SharedSequence<SharingStrategy, Bool> {
        return self.map(!)
    }
}
