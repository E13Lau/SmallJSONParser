import Foundation

@dynamicMemberLookup
public enum JSON {
    case any(Any)
    case dataValue(Data)
    case stringValue(String)
    case intValue(Int)
    case boolValue(Bool)
    case doubleValue(Double)
//    case dateValue(Date)
    case dictionary(Dictionary<String, Any>)
    case array(Array<Any>)
    case null
}

extension JSON {
    
    public static func parse(_ jsonString: String) -> JSON {
        if let data = jsonString.data(using: .utf8) {
            return JSON.parse(data)
        }
        return JSON.null
    }
    
    public static func parse(_ jsonData: Data) -> JSON {
        if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
            if let dict = jsonObject as? Dictionary<String, Any> {
                return JSON.parse(dict)
            }
            if let arr = jsonObject as? Array<Any> {
                return JSON.parse(arr)
            }
        }
        return JSON.null
    }
    
    public static func parse(_ jsonArray: Array<Any>) -> JSON {
        return jsonArray.toJSON()
    }
    
    public static func parse(_ jsonDictinary: Dictionary<String, Any>) -> JSON {
        return jsonDictinary.toJSON()
    }
}

extension JSON {
    public subscript(index: Int) -> JSON {
        if case .array(let arr) = self {
            guard index < arr.count else { return JSON.null }
            let value = arr[index]
            return JSON.any(value).jsonValue
        }
        return JSON.null
    }
    
    public subscript(key: String) -> JSON {
        if case .dictionary(let dict) = self {
            guard let value = dict[key] else { return JSON.null }
            return JSON.any(value).jsonValue
        }
        return JSON.null
    }
    
    public subscript(dynamicMember member: String) -> JSON {
        if case .dictionary(let dict) = self {
            guard let value = dict[member] else { return JSON.null }
            return JSON.any(value).jsonValue
        }
        return JSON.null
    }
}

extension JSON {
    public subscript<T: CanReformToJSONType>(index: Int) -> T {
        if case .array(let arr) = self {
            guard index < arr.count else { return T.init() }
            let value = arr[index]
            guard value is CanReformToJSONType else { return T.init() }
            return (value as? T) ?? T.init()
        }

        return T.init()
    }
    
    public subscript<T: CanReformToJSONType>(key: String) -> T {
        if case .dictionary(let dict) = self {
            guard let value = dict[key] else { return T.init() }
            return (value as? T) ?? T.init()
        }
        return T.init()
    }
    
    public subscript<T: CanReformToJSONType>(dynamicMember member: String) -> T {
        if case .dictionary(let dict) = self {
            guard let value = dict[member] else { return T.init() }
            return (value as? T) ?? T.init()
        }
        return T.init()
    }
}

extension JSON {
    public var jsonValue: JSON {
        switch self {
        case .any(let value):
            switch value {
            case is Int:
                return (value as! Int).toJSON()
            case is String:
                return (value as! String).toJSON()
            case is Data:
                return (value as! Data).toJSON()
            case is Double:
                return (value as! Double).toJSON()
            case is Array<Any>:
                return (value as! Array<Any>).toJSON()
            case is Dictionary<String, Any>:
                return (value as! Dictionary<String, Any>).toJSON()
            case is Bool:
                return (value as! Bool).toJSON()
//            case is Date:
//                return (value as! Date).reformToJSON()
            default:
                return JSON.null
            }
        case .dictionary(let value):
            return value.toJSON()
        case .array(let value):
            return value.toJSON()
        case .stringValue(let value):
            if let data = (value).data(using: .utf8) {
                return JSON.any(data).jsonValue
            }
            return value.toJSON()
        case .dataValue(let value):
            return JSON.any(value).jsonValue
        default: return self
        }
    }
}

extension JSON {
    public var string: String? {
        if case .stringValue(let value) = self {
            return value
        }
        if case .intValue(let value) = self {
            return String(value)
        }
        if case .doubleValue(let value) = self {
            return String(value)
        }
        return nil
    }
    public var stringValue: String {
        return string ?? ""
    }
}

extension JSON {
    public var int: Int? {
        if case .intValue(let value) = self {
            return value
        }
        if case .doubleValue(let value) = self {
            return Int(value)
        }
        if case .stringValue(let value) = self {
            return Int(value)
        }
        return nil
    }
    public var intValue: Int {
        return int ?? 0
    }
}

extension JSON {
    public var double: Double? {
        if case .doubleValue(let value) = self {
            return value
        }
        if case .intValue(let value) = self {
            return Double(value)
        }
        if case .stringValue(let value) = self {
            return Double(value)
        }
        return nil
    }
    public var doubleValue: Double {
        return double ?? 0.0
    }
}

extension JSON {
    public var bool: Bool? {
        if case .boolValue(let value) = self {
            return value
        }
        if case .intValue(let value) = self {
            return value > 0
        }
        return false
    }
    public var boolValue: Bool {
        return bool ?? false
    }
}

//@available(iOS 10.0, tvOS 11.0, OSX 10.13, *)
//extension JSON {
//    public var date: Date? {
//        if case .dateValue(let value) = self {
//            return value
//        }
//        if let str = string {
//            let formatter = ISO8601DateFormatter()
//            if let date = formatter.date(from: str) {
//                return date
//            }
//            if #available(iOS 11.0, *) {
//                formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
//            } else {
//                formatter.formatOptions = [.withInternetDateTime]
//            }
//            if let date = formatter.date(from: str) {
//                return date
//            }
//        }
//        return nil
//    }
//    public var dateValue: Date {
//        return date ?? Date()
//    }
//}

extension JSON {
    public var array: Array<Any>? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    public var arrayValue: Array<Any> {
        return array ?? []
    }
}

extension JSON {
    public var data: Data? {
        if case .dataValue(let value) = self {
            return value
        }
        return nil
    }
    public var dataValue: Data {
        return data ?? Data()
    }
}

extension JSON {
    public var dictionary: Dictionary<String, Any>? {
        if case .dictionary(let dict) = self {
            return dict
        }
        return nil
    }
    public var dictionaryValue: Dictionary<String, Any> {
        return dictionary ?? [:]
    }
}

public protocol CanReformToJSONType {
    init()
    static func reformWith(json: JSON) -> Self
    func toJSON() -> JSON
}
extension Int: CanReformToJSONType {
    public func toJSON() -> JSON {
        return JSON.intValue(self)
    }
    
    public static func reformWith(json: JSON) -> Int {
        return json.intValue
    }
}
extension Double: CanReformToJSONType {
    public func toJSON() -> JSON {
        return JSON.doubleValue(self)
    }
    
    public static func reformWith(json: JSON) -> Double {
        return json.doubleValue
    }
}
extension String: CanReformToJSONType {
    public func toJSON() -> JSON {
        return JSON.stringValue(self)
    }
    
    public static func reformWith(json: JSON) -> String {
        return json.stringValue
    }
}

extension Array: CanReformToJSONType where Element == Any {
    public func toJSON() -> JSON {
        return JSON.array(self)
    }
    
    public static func reformWith(json: JSON) -> Array<Element> {
        return json.arrayValue
    }
}

extension Dictionary: CanReformToJSONType where Value == Any, Key == String {
    public func toJSON() -> JSON {
        return JSON.dictionary(self)
    }
    
    public static func reformWith(json: JSON) -> Dictionary<Key, Value> {
        return json.dictionaryValue
    }
}

extension Bool: CanReformToJSONType {
    public func toJSON() -> JSON {
        return JSON.boolValue(self)
    }
    
    public static func reformWith(json: JSON) -> Bool {
        return json.boolValue
    }
}
extension Data: CanReformToJSONType {
    public func toJSON() -> JSON {
        return JSON.dataValue(self)
    }
    
    public static func reformWith(json: JSON) -> Data {
        return json.dataValue
    }
}

//extension Date: CanReformToJSONType {
//    public static func reformWith(json: JSON) -> Date {
//        if #available(iOS 10.0, tvOS 11.0, OSX 10.13, *) {
//            return json.dateValue
//        } else {
//            if let timestamp = json.int {
//                return Date(timeIntervalSince1970: Double(timestamp))
//            }
//            if let timestampWithSecond = json.double {
//                return Date(timeIntervalSince1970: timestampWithSecond)
//            }
//            return Date()
//        }
//    }
//    public func reformToJSON() -> JSON {
//        return JSON.dateValue(self)
//    }
//}
