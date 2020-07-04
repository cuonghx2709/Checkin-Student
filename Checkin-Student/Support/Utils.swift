//
//  Utils.swift
//  Checkin-Student
//
//  Created by cuong hoang on 5/19/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import Foundation

enum Utils {
    static func l2distance(_ feat1: [Double], _ feat2: [Double]) -> Double {
        return sqrt(zip(feat1, feat2).map { f1, f2 in pow(f2 - f1, 2) }.reduce(0, +))
    }
}
