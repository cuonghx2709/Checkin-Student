//
//  UIFont+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/4/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

enum FontWeight: String {
    case ultraLight = "UltraLight"
    case thin = "Thin"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "SemiBold"
    case bold = "Bold"
    case heavy = "Heavy"
    case black = "Black"
}

extension UIFont {
    static func primaryFont(ofSize fontSize: CGFloat, weight: FontWeight = .regular) -> UIFont {
        guard let font = UIFont(name: "Helvetica-" + weight.rawValue, size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
}
