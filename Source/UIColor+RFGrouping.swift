//
//  UIColor+RFGrouping.swift
//  RFUIColor
//
//  Created by Richard Fa on 2019-09-02.
//

import Foundation

extension UIColor {

    // MARK: Class Functions

    /// Creates a `Array` of `Array` of `UIColor`, that takes in all the `UIColor` values in `colors` and groups them based on closest matching `UIColor` in `segments`. The resulting inner `Array` will contain all the `UIColor` values in `color` that matches each individual `UIColor` in `segments`, with the resulting outer `Array` indexed by the index of `segments`.
    ///
    /// - Parameters:
    ///   - colors:     The `Array` containing `UIColor` values that will be groups.
    ///   - segments:   The `Array` containing `UIColor` values that the `colors` will be grouped by.
    ///
    /// - Returns: The new `Array` of `Array` of `UIColor` result from the grouping.
    static func group(colors: [UIColor], into segments: [UIColor]) -> [[UIColor]] {
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

    /// Creates a `Array` of `Array` of `String`, that takes in all the `String` hexadecimal values in `colors` and groups them based on closest matching `String` hexadecimal value in `segments`. The resulting inner `Array` will contain all the `String` hexadecimal values in `color` that matches each individual `String` hexadecimal value in `segments`, with the resulting outer `Array` indexed by the index of `segments`.
    ///
    /// - Parameters:
    ///   - colors:     The `Array` containing `String` hexadecimal values that will be groups.
    ///   - segments:   The `Array` containing `String` hexadecimal values that the `colors` will be grouped by.
    ///
    /// - Returns: The new `Array` of `Array` of `String` result from the grouping.
    static func group(hexValues colors: [String], into segments: [String]) -> [[String]] {
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
