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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_color_validHexColor_withOctothorpe() {
        let string = "#FF0000"
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
        let string3 = ""
        XCTAssertTrue(string3.containsValidHexValues)
    }

    func test_containsValidHexValue_invalidValues() {
        let string1 = "#FF00000"
        XCTAssertFalse(string1.containsValidHexValues)
        let string2 = "FF00X"
        XCTAssertFalse(string2.containsValidHexValues)
        let string3 = "."
        XCTAssertFalse(string3.containsValidHexValues)
    }
}
