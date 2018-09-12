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
    "main": {
        "temp": 300.39,
        "pressure": 1008,
        "humidity": 94,
        "temp_min": 297.15,
        "temp_max": 303.71
    },
    "visibility": 2300,
    "wind": {
        "speed": 1,
        "deg": 140
    },
    "clouds": {
        "all": 75
    },
    "dt": 1437281131,
    "sys": {
        "type": 1,
        "id": 7405,
        "message": 0.0136,
        "country": "CN",
        "sunrise": 1437253268,
        "sunset": 1437305986
    },
    "id": 1816670,
    "name": "Beijing",
    "cod": 200
}
"""
        let json = JSON.parse(string: example)
        
        let a: Int = json.abc
        XCTAssertEqual(a, 2300)
        XCTAssertEqual(json.coord.lon.doubleValue, 116.4)
        XCTAssertEqual(json.weather[0].id.stringValue, "520")
        XCTAssertEqual(json.wind.speed.intValue, 1)
        XCTAssertEqual(json.wind.speed.intValue, 1)
    }
}
