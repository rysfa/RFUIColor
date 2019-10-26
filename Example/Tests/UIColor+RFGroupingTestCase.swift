//
//  UIColor+RFGroupingTestCase.swift
//  RFUIColor_Tests
//
//  Created by Richard Fa on 2019-10-26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class UIColor_RFGroupingTestCase: XCTestCase {

    func test_groupColors_withSegments_allSegmentsContainsValues() {
        let value1: CGFloat = 0.2
        let value2: CGFloat = 0.8
        let difference: CGFloat = 1.0 / 255.0

        let segment1 = UIColor(red: value1,
                               green: value1,
                               blue: value1,
                               alpha: 1.0)
        let segment2 = UIColor(red: value2,
                               green: value2,
                               blue: value2,
                               alpha: 1.0)

        let color1A = UIColor(red: value1 + difference,
                             green: value1 + difference,
                             blue: value1 + difference,
                             alpha: 1.0)
        let color2A = UIColor(red: value2 + difference,
                             green: value2 + difference,
                             blue: value2 + difference,
                             alpha: 1.0)
        let color1B = UIColor(red: value1 - difference,
                             green: value1 - difference,
                             blue: value1 - difference,
                             alpha: 1.0)
        let color2B = UIColor(red: value2 - difference,
                             green: value2 - difference,
                             blue: value2 - difference,
                             alpha: 1.0)

        let groups = UIColor.group(colors: [color1A, color2A, color1B, color2B], into: [segment1, segment2])
        for group: [UIColor] in groups {
            let isSegment1 = group.contains(color1A) && group.contains(color1B) && !group.contains(color2A) && !group.contains(color2B)
            let isSegment2 = group.contains(color2A) && group.contains(color2B) && !group.contains(color1A) && !group.contains(color1B)
            XCTAssertTrue(isSegment1 || isSegment2)
        }

        let segment1Hex = segment1.hexValue
        let segment2Hex = segment2.hexValue

        let color1AHex = color1A.hexValue
        let color2AHex = color2A.hexValue
        let color1BHex = color1B.hexValue
        let color2BHex = color2B.hexValue

        let groupsHex = UIColor.group(hexValues: [color1AHex, color2AHex, color1BHex, color2BHex], into: [segment1Hex, segment2Hex])
        for group: [String] in groupsHex {
            let isSegment1 = group.contains(color1AHex) && group.contains(color1BHex) && !group.contains(color2AHex) && !group.contains(color2BHex)
            let isSegment2 = group.contains(color2AHex) && group.contains(color2BHex) && !group.contains(color1AHex) && !group.contains(color1BHex)
            XCTAssertTrue(isSegment1 || isSegment2)
        }

    }

    func test_groupColors_withSegments_someSegmentsDoNotContainValues() {
        let value1: CGFloat = 0.2
        let value2: CGFloat = 0.8
        let difference: CGFloat = 1.0 / 255.0

        let segment1 = UIColor(red: value1,
                               green: value1,
                               blue: value1,
                               alpha: 1.0)
        let segment2 = UIColor(red: value2,
                               green: value2,
                               blue: value2,
                               alpha: 1.0)

        let color1A = UIColor(red: value1 + difference,
                             green: value1 + difference,
                             blue: value1 + difference,
                             alpha: 1.0)
        let color1B = UIColor(red: value1 - difference,
                             green: value1 - difference,
                             blue: value1 - difference,
                             alpha: 1.0)
        let color1C = UIColor(red: value1,
                             green: value1,
                             blue: value1,
                             alpha: 1.0)

        let groups = UIColor.group(colors: [color1A, color1B, color1C], into: [segment1, segment2])
        for group: [UIColor] in groups {
            let containsAll = group.contains(color1A) && group.contains(color1B) && group.contains(color1C)
            let containsNone = !group.contains(color1A) && !group.contains(color1B) && !group.contains(color1C)
            XCTAssertTrue(containsAll || containsNone)
        }

        let segment1Hex = segment1.hexValue
        let segment2Hex = segment2.hexValue

        let color1AHex = color1A.hexValue
        let color1BHex = color1B.hexValue
        let color1CHex = color1C.hexValue

        let groupsHex = UIColor.group(hexValues: [color1AHex, color1BHex, color1CHex], into: [segment1Hex, segment2Hex])
        for group: [String] in groupsHex {
            let containsAll = group.contains(color1AHex) && group.contains(color1BHex) && group.contains(color1CHex)
            let containsNone = !group.contains(color1AHex) && !group.contains(color1BHex) && !group.contains(color1CHex)
            XCTAssertTrue(containsAll || containsNone)
        }

    }
}
