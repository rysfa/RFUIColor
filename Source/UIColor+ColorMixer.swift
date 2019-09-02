//
//  UIColor+ColorMixer.swift
//  ColorMixer
//
//  Created by Richard Fa on 2018-05-12.
//

import UIKit

let rgbRedWeight: Int = 299
let rgbGreenWeight: Int = 587
let rgbBlueWeight: Int = 114

extension UIColor {

    var hue: CGFloat {
        var hue: CGFloat = 0
        self.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

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

    var brightness: CGFloat {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return ((red * CGFloat(rgbRedWeight)) + (green * CGFloat(rgbGreenWeight)) + (blue * CGFloat(rgbBlueWeight))) / 1000
    }

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

    func similarity(to color: UIColor) -> CGFloat {
        let difference: CGFloat = CGFloat(rgbValueDifference(to: color)) / CGFloat((rgbRedWeight + rgbBlueWeight + rgbGreenWeight))
        return 1.0 - difference
    }

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

    func indexForBestMatch(in hexValues: [String]) -> Int {
        var allColors = [UIColor]()
        for hexValue in hexValues {
            if let color = hexValue.color {
                allColors.append(color)
            }
        }
        return indexForBestMatch(in: allColors)
    }

    static func split(colors: [UIColor], into segments: [UIColor]) -> [[UIColor]] {
        guard segments.count > 1 else {
            return [colors]
        }

        var segmentedColors = [[UIColor]]()
        for _ in 0..<segments.count {
            segmentedColors.append([UIColor]())
        }

        colors.forEach { (color: UIColor) in
            let index = color.indexForBestMatch(in: segments)
            segmentedColors[index].append(color)
        }
        return segmentedColors
    }

    static func split(hexValues colors: [String], into segments: [String]) -> [[String]] {
        guard segments.count > 1 else {
            return [colors]
        }

        var segmentedColors = [[String]]()
        for _ in 0..<segments.count {
            segmentedColors.append([String]())
        }

        colors.forEach { (hexColor: String) in
            if let color = hexColor.color {
                let index = color.indexForBestMatch(in: segments)
                segmentedColors[index].append(hexColor)
            }
        }
        return segmentedColors
    }
}
