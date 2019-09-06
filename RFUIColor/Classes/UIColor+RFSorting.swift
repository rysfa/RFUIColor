//
//  UIColor+RFSorting.swift
//  RFUIColor
//
//  Created by Richard Fa on 2019-01-05.
//

import UIKit

public enum RFSortColorsBy {
    case brightness
    case hue
}

extension UIColor {

    // MARK: Class Functions

    /// Creates a `Array` of `UIColor`, that takes in all the `UIColor` values in `colors` and rearranges the values based on the sorting method `sort` and the order `ascending`.
    ///
    /// - Parameters:
    ///   - colors:     The `Array` of `UIColor` values that will be sorted.
    ///   - sort:       The `SortColorsBy` sorting method.
    ///   - ascending:  The `Bool` value of whether to order by ascending or descending order, `true` by default.
    ///
    /// - Returns: The new `Array` of `UIColor` result from the sorting.
    public static func sort(colors: [UIColor],
                            sortedBy sort: RFSortColorsBy,
                            ascending: Bool = true) -> [UIColor] {
        return colors.sorted(by: { (colorA, colorB) -> Bool in
            return compare(colorA: colorA,
                           colorB: colorB,
                           sortedBy: sort,
                           ascending: ascending)
        })
    }

    /// Creates a `Array` of `String` hexadecimal values, that takes in all the `String` hexadecimal values in `colors` and rearranges the values based on the sorting method `sort` and the order `ascending`.
    ///
    /// - Parameters:
    ///   - colors:     The `Array` of `String` hexadecimal values that will be sorted.
    ///   - sort:       The `SortColorsBy` sorting method.
    ///   - ascending:  The `Bool` value of whether to order by ascending or descending order, `true` by default.
    ///
    /// - Returns: The new `Array` of `String` hexadecimal values result from the sorting.
    public static func sort(hexValues colors: [String],
                            sortedBy sort: RFSortColorsBy,
                            ascending: Bool = true) -> [String] {
        return colors.sorted(by: { (colorHexA, colorHexB) -> Bool in
            guard let colorB = colorHexB.color else {
                return ascending
            }
            guard let colorA = colorHexA.color else {
                return !ascending
            }
            return compare(colorA: colorA,
                           colorB: colorB,
                           sortedBy: sort,
                           ascending: ascending)
        })
    }

    /// Creates a `Array` of `UIColor`, that takes in all the `UIColor` values in `colors` and rearranges the values based on closest matching `UIColor` in `segments` and the order `ascending`.
    ///
    /// - Parameters:
    ///   - colors:     The `Array` of `UIColor` values that will be sorted.
    ///   - segments:   The `Array` containing `UIColor` values that the `colors` will be sorted by.
    ///   - ascending:  The `Bool` value of whether to order by ascending or descending order, `true` by default.
    ///
    /// - Returns: The new `Array` of `UIColor` result from the sorting.
    public static func sort(colors: [UIColor],
                            into segments: [UIColor],
                            ascending: Bool = true) -> [UIColor] {
        return colors.sorted(by: { (colorA, colorB) -> Bool in
            return compare(colorA: colorA,
                           colorB: colorB,
                           into: segments,
                           ascending: ascending)
        })
    }

    /// Creates a `Array` of `String` hexadecimal values, that takes in all the `String` hexadecimal values in `colors` and rearranges the values based on closest matching `String` hexadecimal value in `segments` and the order `ascending`.
    ///
    /// - Parameters:
    ///   - colors:     The `Array` of `String` hexadecimal values that will be sorted.
    ///   - segments:   The `Array` containing `String` hexadecimal values that the `colors` will be sorted by.
    ///   - ascending:  The `Bool` value of whether to order by ascending or descending order, `true` by default.
    ///
    /// - Returns: The new `Array` of `String` hexadecimal values result from the sorting.
    public static func sort(hexValues colors: [String],
                            into segments: [String],
                            ascending: Bool = true) -> [String] {
        var colorSegments = [UIColor]()
        segments.forEach { (segment: String) in
            if let color = segment.color {
                colorSegments.append(color)
            }
        }
        return colors.sorted(by: { (colorHexA, colorHexB) -> Bool in
            guard let colorB = colorHexB.color else {
                return ascending
            }
            guard let colorA = colorHexA.color else {
                return !ascending
            }
            return compare(colorA: colorA,
                           colorB: colorB,
                           into: colorSegments,
                           ascending: ascending)
        })
    }

    // MARK: Private Class Functions

    fileprivate static func compare(colorA: UIColor,
                                    colorB: UIColor,
                                    sortedBy: RFSortColorsBy,
                                    ascending: Bool = true) -> Bool {
        switch sortedBy {
        case .brightness:
            let orderedIfAscending = colorA.brightness > colorB.brightness
            return ascending ? orderedIfAscending : !orderedIfAscending
        case .hue:
            let orderedIfAscending = colorA.hue > colorB.hue
            return ascending ? orderedIfAscending : !orderedIfAscending
        }
    }

    fileprivate static func compare(colorA: UIColor,
                                    colorB: UIColor,
                                    into segments: [UIColor],
                                    ascending: Bool = true) -> Bool {
        guard segments.count > 1 else {
            return true
        }

        let segmentColorIndexA = colorA.indexForBestMatch(in: segments)
        let segmentColorIndexB = colorB.indexForBestMatch(in: segments)
        if segmentColorIndexA != segmentColorIndexB {
            return segmentColorIndexA < segmentColorIndexB
        }
        if segmentColorIndexA == 0 {
            return colorA.rgbValueDifference(to: segments[1]) > colorB.rgbValueDifference(to: segments[1])
        }
        if segmentColorIndexA == segments.count - 1 {
            return colorA.rgbValueDifference(to: segments[segments.count - 2]) < colorB.rgbValueDifference(to: segments[segments.count - 2])
        }

        let leftSimilarityA = -colorA.rgbValueDifference(to: segments[segmentColorIndexA - 1])
        let leftSimilarityB = -colorB.rgbValueDifference(to: segments[segmentColorIndexA - 1])
        let rightSimilarityA = colorA.rgbValueDifference(to: segments[segmentColorIndexA + 1])
        let rightSimilarityB = colorB.rgbValueDifference(to: segments[segmentColorIndexA + 1])
        let similarityA = abs(leftSimilarityA) < abs(rightSimilarityA) ? leftSimilarityA : rightSimilarityA
        let similarityB = abs(leftSimilarityB) < abs(rightSimilarityB) ? leftSimilarityB : rightSimilarityB
        let orderedIfAscending = similarityA < similarityB
        return ascending ? orderedIfAscending : !orderedIfAscending
    }
}
