# SmallJSONParser

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![](https://img.shields.io/cocoapods/v/SmallJSONParser.svg?style=flat)
![](https://img.shields.io/badge/platform-ios-osx-watchos-tvos-lightgrey.svg)

A lightweight and small JSON parser for Swift.

Based on "Dynamic Member Lookup" Types.Learn more here [Introduce User-defined "Dynamic Member Lookup" Types](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md).

```swift
let string = "{\"id\": 923, \"name\": \"hello\", \"coord\":{\"lon\": 116.4, \"lat\": 39.91}}"
let json = JSON.parse(string: string)
let id = json.id.intValue    //   923
let name: String = json.name    //   hello
let lon: Double = json.coord.lon    //  116.4
```

## Requirements

- Swift 4.2 or later

## Installation

#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "chn-lyzhi/SmallJSONParser"` to your Cartfile.
- Run `carthage update`.
- Link your app with `SmallJSONParser.framework` in `Carthage/Build`.

#### [CocoaPods](https://github.com/cocoapods/cocoapods)

(coming soon)

- Insert `pod 'SmallJSONParser'` to your Podfile.
- Run `pod install`.
