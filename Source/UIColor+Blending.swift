//
//  UIColor+Blending.swift
//  ColorMixer
//
//  Created by Richard Fa on 2019-01-05.
//

import UIKit

extension UIColor {

    func blend(with color: UIColor,
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

    static func blend(colors: [UIColor],
                      at distribution: [CGFloat] = [CGFloat]()) -> UIColor {
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
            if distribution.count > i && distributionTotal + distribution[i] <= 1.0 {
                if distribution[i] > 0.0 {
                    red += red1 / distribution[i]
                    green += green1 / distribution[i]
                    blue += blue1 / distribution[i]
                    alpha += alpha1 / distribution[i]
                }
                distributionTotal += distribution[i]
            } else {
                // Equally distribute the remainder of the colors
                let distribution1: CGFloat = (1.0 - distributionTotal)
                if distribution1 > 0.0 {
                    red += red1 / distribution1
                    green += green1 / distribution1
                    blue += blue1 / distribution1
                    alpha += alpha1 / distribution1
                }
                distributionTotal += distribution[i]
            }
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
