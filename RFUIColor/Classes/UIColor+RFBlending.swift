//
//  UIColor+RFBlending.swift
//  RFUIColor
//
//  Created by Richard Fa on 2019-01-05.
//

import UIKit

extension UIColor {

    // MARK: Functions

    /// Creates a `UIColor`, with the rgb values combined between `self` and `color`, with the `distribution` determining the balance of the rgb values from `self` and `color`.
    ///
    /// - Parameters:
    ///   - color:          The other `UIColor` value that will be blended with `self`.
    ///   - distribution:   The `CGFloat` value that determines the balance between the colors, `0.5` (evenly distributed) by default.
    ///
    /// - Returns: The new `UIColor` result from the blend.
    public func blend(with color: UIColor,
                      at distribution: CGFloat = 0.5) -> UIColor {
        var red1: CGFloat = 0.0
        var green1: CGFloat = 0.0
        var blue1: CGFloat = 0.0
        var alpha1: CGFloat = 0.0
        getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        var red2: CGFloat = 0.0
        var green2: CGFloat = 0.0
        var blue2: CGFloat = 0.0
        var alpha2: CGFloat = 0.0
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        let red: CGFloat = (red1 * (1.0 - distribution)) + (red2 * distribution)
        let green: CGFloat = (green1 * (1.0 - distribution)) + (green2 * distribution)
        let blue: CGFloat = (blue1 * (1.0 - distribution)) + (blue2 * distribution)
        let alpha: CGFloat = (alpha1 * (1.0 - distribution)) + (alpha2 * distribution)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: Class Functions

    /// Creates a `UIColor`, with the rgb values combined between all the values in `colors`, with the `distribution` with an array of values, each determining the percentage of distribution of the color of the same index in `colors`.
    ///
    /// - Parameters:
    ///   - colors:         The `Array` containing `UIColor` values that will be blended.
    ///   - distribution:   The `Array` containing `CGFloat` values that determines the percentage of distribution of the colors, with the total sum being 1.0, `[]` (evenly distributed or `1.0/colors.count`) by default.
    ///
    /// - Returns: The new `UIColor` result from the blend.
    public static func blend(colors: [UIColor],
                             at distribution: [CGFloat] = [CGFloat]()) -> UIColor? {
        guard colors.count > 0  else {
            return nil
        }
        if distribution.count > 0 {
            if colors.count != distribution.count {
                return nil
            }
            if distribution.reduce(0.0, +) != 1.0 {
                return nil
            }
        }
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        var distributionTotal: CGFloat = 0.0

        for i in 0..<colors.count {
            let color = colors[i]
            var red1: CGFloat = 0.0
            var green1: CGFloat = 0.0
            var blue1: CGFloat = 0.0
            var alpha1: CGFloat = 0.0
            color.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
            let distributionValue: CGFloat = distribution.count > 0 ? distribution[i] : (1.0 / CGFloat(colors.count))
            guard distributionTotal + distributionValue <= 1.0, distributionValue >= 0.0 else {
                return nil
            }
            red += red1 / distributionValue
            green += green1 / distributionValue
            blue += blue1 / distributionValue
            alpha += alpha1 / distributionValue
            distributionTotal += distributionValue
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
