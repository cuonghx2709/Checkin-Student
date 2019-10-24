//
//  String+.swift
//  fGoal
//
//  Created by Phạm Xuân Tiến on 5/16/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension StringProtocol {
//    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
//        var result: [Range<Index>] = []
//        var startIndex = self.startIndex
//        while startIndex < endIndex,
//            let range = self[startIndex...].range(of: string, options: options) {
//                result.append(range)
//                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
//                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        return result
//    }
}

extension String {
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8),
                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                              documentAttributes: nil).string
        
        return decoded ?? self
    }
    
    /// Find strings matched by "#" pattern.
    ///
    /// - Returns: Array of strings
    func hashtags() -> [String] {
        return matches(regex: "#[a-z0-9]+").map {
            $0.replacingOccurrences(of: "#", with: "")
        }
    }
    
    /// Find matching strings against regex patterns.
    ///
    /// - Parameter regex: regex pattern
    /// - Returns: Array of strings
    func matches(regex: String) -> [String] {
        if let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) {
            let string = self as NSString
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
            }
        }
        return []
    }
    
    /// Short methods for replacingOccurrences
    func replace(_ of: String, _ with: String) -> String {
        return replacingOccurrences(of: of, with: with)
    }
    
    /// Get numbers characters from a string
    ///
    /// - Returns: Double value
    func getNumber() -> Double? {
        let characterSet = CharacterSet(charactersIn: "0123456789.")
        let numberArray = components(separatedBy: characterSet.inverted)
        return Double(numberArray.joined())
    }
    
    /// Standline String
    ///
    /// - Returns: String removed left and right space character
    func standline() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
