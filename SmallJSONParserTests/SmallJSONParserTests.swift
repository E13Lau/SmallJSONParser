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
        let json = JSON.parse(example)
        
        for (index, item) in json.weather.arrayValue.enumerated() {
            if index == 0 {
                XCTAssertEqual(item.id.intValue, 520)
                XCTAssertEqual(item.icon.stringValue, "09d")
            }
            if index == 1 {
                XCTAssertEqual(item.id.intValue, 701)
                XCTAssertEqual(item.icon.stringValue, "50d")
            }
        }
        XCTAssertEqual(json.coord.lon.doubleValue, 116.4)
        XCTAssertEqual(json.weather[0].id.intValue, 520)
        XCTAssertEqual(json.base.stringValue, "stations")
        let lon: Double = json.coord.lon
        XCTAssertEqual(lon, 116.4)
        let isAdmin: Bool = json.isAdmin
        XCTAssertTrue(isAdmin)
    }
    
    func testArray() {
        let example: [Any] = ["name", 0, 123, false, true]
        
        let json = JSON.parse(example)
        XCTAssertEqual(json[0].stringValue, "name")
        XCTAssertEqual(json[2].intValue, 123)
        XCTAssertEqual(json[3].boolValue, false)
        XCTAssertEqual(json[4].boolValue, true)
    }
    
    func testDict() {
        let example: [String: Any] = ["name": "jack",
                                      "age": 26,
                                      "id": 38248]
        
        let json = JSON.parse(example)
        XCTAssertEqual(json.name.stringValue, "jack")
        XCTAssertEqual(json.age.intValue, 26)
        XCTAssertEqual(json.id.intValue, 38248)
        XCTAssertNotEqual(json.id.intValue, 88888)
    }
}
