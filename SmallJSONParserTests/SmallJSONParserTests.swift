//
//  SmallJSONParserTests.swift
//  SmallJSONParserTests
//
//  Created by Benq on 2018/9/12.
//

import XCTest
import SmallJSONParser

class SmallJSONParserTests: XCTestCase {
    func testExample() {
        let example =
        """
{
    "coord": {
        "lon": 116.4,
        "lat": 39.91
    },
    "weather": [
        {
        "id": 520,
        "main": "Rain",
        "icon": "09d"
        },
        {
        "id": 701,
        "main": "Mist",
        "icon": "50d"
        }
    ],
    "base": "stations",
    "isAdmin": true,
}
"""
        let json = JSON.parse(string: example)
        
        XCTAssertEqual(json.coord.lon.doubleValue, 116.4)
        XCTAssertEqual(json.weather[0].id.intValue, 520)
        XCTAssertEqual(json.base.stringValue, "stations")
        let lon: Double = json.coord.lon
        XCTAssertEqual(lon, 116.4)
        let isAdmin: Bool = json.isAdmin
        XCTAssertTrue(isAdmin)
    }
}
