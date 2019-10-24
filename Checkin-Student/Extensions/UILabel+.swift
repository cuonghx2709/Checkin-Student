//
//  UILabel+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 6/24/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension UILabel {
    /// Style AttributedString by HTML tag
    func styleByTag() {
        guard let text = text else { return }
        let newLabelText = NSMutableAttributedString(string: text)
        let pattern = "(?<=<b>).*?(?=<\\/b>)|(?<=<i>).*?(?=<\\/i>)"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let matches = regex.matches(in: text,
                                        options: [],
                                        range: NSRange(location: 0, length: text.utf16.count))
            matches.forEach { match in
                let range = NSRange(location: match.range.location - 3, length: 3)
                let matchText = (text as NSString).substring(with: range)
                var attribute: [NSAttributedString.Key: Any] = [:]
                switch matchText {
                case "<b>":
                    attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
                case "<i>":
                    attribute = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: font.pointSize)]
                default:
                    break
                }
                newLabelText.setAttributes(attribute, range: match.range)
            }
        }
        newLabelText.mutableString.replaceOccurrences(of: "<b>|</b>|<i>|</i>",
                                                      with: "",
                                                      options: .regularExpression,
                                                      range: NSRange(location: 0,
                                                                     length: newLabelText.length))
        attributedText = newLabelText
    }
}
