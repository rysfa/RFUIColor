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

    func test_blendColors_withSameDistribution() {
        let value1: CGFloat = 0.1
        let value2: CGFloat = 0.6
        let value3: CGFloat = 0.8

        let color1 = UIColor(red: value1,
                             green: value1,
                             blue: value1,
                             alpha: 1.0)
        let color2 = UIColor(red: value2,
                             green: value2,
                             blue: value2,
                             alpha: 1.0)
        let color3 = UIColor(red: value3,
                             green: value3,
                             blue: value3,
                             alpha: 1.0)
        let color4 = UIColor.blend(colors: [color1, color2, color3])

        let value4: CGFloat = (value1 + value2 + value3) / 3.0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        XCTAssertNotNil(color4)
        color4!.getRed(&red,
                      green: &green,
                      blue: &blue,
                      alpha: &alpha)

        XCTAssertEqual(red, value4)
        XCTAssertEqual(green, value4)
        XCTAssertEqual(blue, value4)
    }

    func test_blendColors_withDifferentDistribution() {
        let value1: CGFloat = 0.2
        let value2: CGFloat = 0.5
        let value3: CGFloat = 1.0
        let dist1: CGFloat = 0.5
        let dist2: CGFloat = 0.4
        let dist3: CGFloat = 0.1

        let color1 = UIColor(red: value1,
                             green: value1,
                             blue: value1,
                             alpha: 1.0)
        let color2 = UIColor(red: value2,
                             green: value2,
                             blue: value2,
                             alpha: 1.0)
        let color3 = UIColor(red: value3,
                             green: value3,
                             blue: value3,
                             alpha: 1.0)
        let color4 = UIColor.blend(colors: [color1, color2, color3], at: [dist1, dist2, dist3])

        let value4: CGFloat = (value1 * dist1) + (value2 * dist2) + (value3 * dist3)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        XCTAssertNotNil(color4)
        color4!.getRed(&red,
                      green: &green,
                      blue: &blue,
                      alpha: &alpha)

        XCTAssertEqual(red, value4)
        XCTAssertEqual(green, value4)
        XCTAssertEqual(blue, value4)
    }

    func test_blendColors_withInvalidDistributions() {
        XCTAssertNil(UIColor.blend(colors: [UIColor.red, UIColor.green, UIColor.blue], at: [0.4, 0.4, 0.4]))
        XCTAssertNil(UIColor.blend(colors: [UIColor.red, UIColor.green, UIColor.blue], at: [0.3, 0.3, 0.3]))
        XCTAssertNil(UIColor.blend(colors: [UIColor.red, UIColor.green, UIColor.blue], at: [0.5, 0.5]))
        XCTAssertNil(UIColor.blend(colors: [UIColor.red, UIColor.green, UIColor.blue], at: [0.2, 0.2, 0.3, 0.3]))
        XCTAssertNotNil(UIColor.blend(colors: [UIColor.red, UIColor.green, UIColor.blue], at: []))
    }
}
