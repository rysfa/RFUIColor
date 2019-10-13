//
//  String+RFColorTestCase.swift
//  RFUIColor_Tests
//
//  Created by Richard Fa on 2019-10-06.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import RFUIColor

class String_RFColorTestCase: XCTestCase {

    func test_color_validHexColor_withOctothorpe() {
        let string = "#FF0000"
        let color = UIColor.red
        XCTAssertNotNil(string.color)
        XCTAssertEqual(string.color, color)
    }

    func test_color_validHexColor_partialWithOctothorpe() {
        let string = "#F00"
        let color = UIColor.red
        XCTAssertNotNil(string.color)
        XCTAssertEqual(string.color, color)
    }

    func test_color_validHexColor_noOctothorpe() {
        let string = "FF0000"
        let color = UIColor.red
        XCTAssertNotNil(string.color)
        XCTAssertEqual(string.color, color)
    }

    func test_color_validHexColor_partialNoOctothorpe() {
        let string = "F00"
        let color = UIColor.red
        XCTAssertNotNil(string.color)
        XCTAssertEqual(string.color, color)
    }

    func test_color_invalidHexColor() {
        let string1 = "#FF000"
        XCTAssertNil(string1.color)
        let string2 = "FF000"
        XCTAssertNil(string2.color)
    }

    func test_containsValidHexValue_validValues() {
        let string1 = "#FF000"
        XCTAssertTrue(string1.containsValidHexValues)
        let string2 = "FF000"
        XCTAssertTrue(string2.containsValidHexValues)
        let string3 = "#"
        XCTAssertTrue(string3.containsValidHexValues)
        let string4 = ""
        XCTAssertTrue(string4.containsValidHexValues)
    }

    func test_containsValidHexValue_invalidValues() {
        let string1 = "#FF00000"
        XCTAssertFalse(string1.containsValidHexValues)
        let string2 = "FF00X"
        XCTAssertFalse(string2.containsValidHexValues)
        let string3 = "."
        XCTAssertFalse(string3.containsValidHexValues)
        let string4 = "##"
        XCTAssertFalse(string4.containsValidHexValues)
    }

    func test_isHexString_validValues() {
        let string1 = "#FF0000"
        XCTAssertTrue(string1.isValidHexValue)
        let string2 = "FF0000"
        XCTAssertTrue(string2.isValidHexValue)
        let string3 = "F00"
        XCTAssertTrue(string3.isValidHexValue)
    }

    func test_isHexString_invalidValues() {
        let string1 = "#FF000"
        XCTAssertFalse(string1.isValidHexValue)
        let string2 = "#"
        XCTAssertFalse(string2.isValidHexValue)
        let string3 = ""
        XCTAssertFalse(string3.isValidHexValue)
    }
}
