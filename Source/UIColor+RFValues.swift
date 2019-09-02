//
//  UIColor+RFValues.swift
//  RFUIColor
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

let rgbRedWeight: Int = 299
let rgbGreenWeight: Int = 587
let rgbBlueWeight: Int = 114

extension UIColor {

    /// The hue value of `self`.
    /// Reference: https://en.wikipedia.org/wiki/Hue
    ///
    /// - Returns: The `CGFloat` value, between 0.0 and 1.0.
    var hue: CGFloat {
        var hue: CGFloat = 0
        self.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

    /// The hexadecimal value of `self`, including the prefixed octothorpe.
    /// Reference: https://en.wikipedia.org/wiki/Web_colors
    ///
    /// - Returns: The `String` hexadecimal value.
    var hexValue: String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(red * 255)),
                      lroundf(Float(green * 255)),
                      lroundf(Float(blue * 255)))
    }

    /// The level of brightness of `self`.
    /// Reference: https://en.wikipedia.org/wiki/Brightness
    ///
    /// - Returns: The `CGFloat` value, between 0.0 and 1.0 (higher value representing higher brightness).
    var brightness: CGFloat {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return ((red * CGFloat(rgbRedWeight)) + (green * CGFloat(rgbGreenWeight)) + (blue * CGFloat(rgbBlueWeight))) / 1000
    }

    /// The complementary `UIColor` of `self`.
    /// Reference: https://en.wikipedia.org/wiki/Complementary_colors
    ///
    /// - Returns: The `UIColor` value.
    var complement: UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: 1.0 - red,
                       green: 1.0 - green,
                       blue: 1.0 - blue,
                       alpha: 1.0)
    }

    /// Creates a `CGFloat`, with the level of similarity between `self` and the `UIColor value of `color`.
    ///
    /// - Parameters:
    ///   - color:  The other `UIColor` value that will be compared with `self`.
    ///
    /// - Returns: The `CGFloat` value, between 0.0 and 1.0 (higher value representing higher similarity).
    func similarity(to color: UIColor) -> CGFloat {
        let difference: CGFloat = CGFloat(rgbValueDifference(to: color)) / CGFloat((rgbRedWeight + rgbBlueWeight + rgbGreenWeight))
        return 1.0 - difference
    }

    /// Creates an `Int`, with the amount of difference between `self` and the `UIColor value of `color`, in terms of rgb values.
    ///
    /// - Parameters:
    ///   - color:  The other `UIColor` value that will be compared with `self`.
    ///
    /// - Returns: The `Int` value, between 0 and 1,000 (higher value representing higher difference).
    func rgbValueDifference(to color: UIColor) -> Int {
        var red1: CGFloat = 0.0
        var green1: CGFloat = 0.0
        var blue1: CGFloat = 0.0
        getRed(&red1, green: &green1, blue: &blue1, alpha: nil)
        var red2: CGFloat = 0.0
        var green2: CGFloat = 0.0
        var blue2: CGFloat = 0.0
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: nil)

        let redValue: CGFloat = abs(red1 - red2) * CGFloat(rgbRedWeight)
        let greenValue: CGFloat = abs(green1 - green2) * CGFloat(rgbGreenWeight)
        let blueValue: CGFloat = abs(blue1 - blue2) * CGFloat(rgbBlueWeight)
        return Int(redValue + greenValue + blueValue)
    }

    /// Creates an `Int`, that represents the index in `colors` in which `self` has the best fit.
    ///
    /// - Parameters:
    ///   - colors:  The `Array` of `UIColor` values.
    ///
    /// - Returns: The `Int` resulting index.
    func indexForBestMatch(in colors: [UIColor]) -> Int {
        var bestMatchIndex: Int = -1
        for color in colors {
            if bestMatchIndex < 0 || rgbValueDifference(to: color) < rgbValueDifference(to: colors[bestMatchIndex]) {
                if let newColorIndex = colors.firstIndex(of: color) {
                    bestMatchIndex = newColorIndex
                }
            }
        }
        return bestMatchIndex
    }

    /// Creates an `Int`, that represents the index in `colors` in which `self` has the best fit.
    ///
    /// - Parameters:
    ///   - colors:  The `Array` of `String` hexadecimal values.
    ///
    /// - Returns: The `Int` resulting index.
    func indexForBestMatch(in hexValues: [String]) -> Int {
        var allColors = [UIColor]()
        for hexValue in hexValues {
            if let color = hexValue.color {
                allColors.append(color)
            }
        }
        return indexForBestMatch(in: allColors)
    }
}
