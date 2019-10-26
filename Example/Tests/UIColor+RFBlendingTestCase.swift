//
//  UIColor+RFBlendingTestCase.swift
//  RFUIColor_Tests
//
//  Created by Richard Fa on 2019-10-26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class UIColor_RFBlendingTestCase: XCTestCase {

    func test_blendColor_withDifferentColor() {
        let value1: CGFloat = 0.0
        let value2: CGFloat = 1.0

        let color1 = UIColor(red: value1,
                             green: value1,
                             blue: value1,
                             alpha: 1.0)
        let color2 = UIColor(red: value2,
                             green: value2,
                             blue: value2,
                             alpha: 1.0)
        let color3 = color1.blend(with: color2)

        let value3: CGFloat = (value1 + value2) / 2.0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color3.getRed(&red,
                      green: &green,
                      blue: &blue,
                      alpha: &alpha)

        XCTAssertEqual(red, value3)
        XCTAssertEqual(green, value3)
        XCTAssertEqual(blue, value3)
    }

    func test_blendColor_withDifferentColor_withDifferenceDistribution() {
        let value1: CGFloat = 0.0
        let value2: CGFloat = 1.0
        let dist: CGFloat = 0.7

        let color1 = UIColor(red: value1,
                             green: value1,
                             blue: value1,
                             alpha: 1.0)
        let color2 = UIColor(red: value2,
                             green: value2,
                             blue: value2,
                             alpha: 1.0)
        let color3 = color1.blend(with: color2, at: dist)

        let value3: CGFloat = (value1 * (1.0 - dist)) + (value2 * dist)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color3.getRed(&red,
                      green: &green,
                      blue: &blue,
                      alpha: &alpha)

        XCTAssertEqual(red, value3)
        XCTAssertEqual(green, value3)
        XCTAssertEqual(blue, value3)
    }

    func test_blendColor_withSameColor() {
        let value: CGFloat = 0.5

        let color1 = UIColor(red: value,
                             green: value,
                             blue: value,
                             alpha: 1.0)
        let color2 = UIColor(red: value,
                             green: value,
                             blue: value,
                             alpha: 1.0)
        let color3 = color1.blend(with: color2)

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color3.getRed(&red,
                      green: &green,
                      blue: &blue,
                      alpha: &alpha)

        XCTAssertEqual(red, value)
        XCTAssertEqual(green, value)
        XCTAssertEqual(blue, value)
    }
}
