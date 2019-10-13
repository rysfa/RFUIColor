//
//  String+RFColor.swift
//  RFUIColor
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

extension String {

    // MARK: Variables

    /// The `UIColor` value of the hexadecimal value of `self`. If `self` is not a valid hexadecimal value, returns nil.
    public var color: UIColor? {
        guard var string = completeHexString() else {
            return nil
        }
        string = string.replacingOccurrences(of: "#", with: "").uppercased()
        var red: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var green: CGFloat = 0.0
        var rgb: UInt32 = 0
        guard Scanner(string: string).scanHexInt32(&rgb) else {
            return nil
        }
        red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        blue = CGFloat(rgb & 0x0000FF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    /// The `Bool` indicator of whether or not `self` is a a partial string of a hexadecimal value (e.g. if the string contains valid hexadecimal values, but is not necessarily a full value).
    public var containsValidHexValues: Bool {
        return isHexString(isComplete: false)
    }

    /// The `Bool` indicator of whether or not `self` is a valid hexadecimal value.
    public var isValidHexValue: Bool {
        return isHexString(isComplete: true)
    }

    // MARK: Private Functions

    fileprivate func isHexString(isComplete: Bool = true) -> Bool {
        var hexString = Substring(self)
        if first == "#" {
            hexString = dropFirst()
        }
        let isLengthCorrect = hexString.count == 3 || hexString.count == 6
        guard (isComplete && isLengthCorrect) || (!isComplete && hexString.count <= 6) else {
            return false
        }
        let validCharacters = CharacterSet(charactersIn: "0123456789ABCDEF")
        return hexString.rangeOfCharacter(from: validCharacters.inverted) == nil
    }

    fileprivate func completeHexString() -> String? {
        guard isHexString() else {
            return nil
        }
        let currentString = replacingOccurrences(of: "#", with: "").uppercased()
        if currentString.count == 6 {
            return self
        }
        var newString = first == "#" ? "#" : ""
        for value in currentString {
            newString = newString + String(value) + String(value)
        }
        return newString
    }
}
