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
    var color: UIColor? {
        guard isHexString() else {
            return nil
        }
        let string = replacingOccurrences(of: "#", with: "").uppercased()
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
    var containsValidHexValues: Bool {
        return isHexString(isComplete: false)
    }

    /// The `Bool` indicator of whether or not `self` is a valid hexadecimal value.
    var isValidHexValue: Bool {
        return isHexString(isComplete: true)
    }

    // MARK: Private Functions

    fileprivate func isHexString(isComplete: Bool = true) -> Bool {
        var hexString = Substring(self)
        if self.first == "#" {
            hexString = dropFirst()
        }
        guard (isComplete && hexString.count == 6) || (!isComplete && hexString.count <= 6) else {
            return false
        }
        let validCharacters = CharacterSet(charactersIn: "0123456789ABCDEF")
        return hexString.rangeOfCharacter(from: validCharacters.inverted) == nil
    }
}
