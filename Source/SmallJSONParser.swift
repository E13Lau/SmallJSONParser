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
    case dictionaryValue(Dictionary<String, Any>)
    case arrayValue(Array<Any>)
    case dictionary(Dictionary<String, JSON>)
    case array(Array<JSON>)
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
    
    fileprivate static func parse(value: Any) -> JSON {
        switch value {
        case is Dictionary<String, JSON>:
            return JSON.dictionary(value as! Dictionary<String, JSON>)
        case is Array<JSON>:
            return JSON.array(value as! Array<JSON>)
        case is Data:
            if let dict = try? JSONSerialization.jsonObject(with: (value as! Data), options: []) as? Dictionary<String, Any> {
                return JSON.parse(value:dict as Any)
            }
            if let array = try? JSONSerialization.jsonObject(with: (value as! Data), options: []) as? Array<Any> {
                return JSON.parse(value:array as Any)
            }
            return JSON.any(value)
        case is Dictionary<String, Any>:
            let dict = value as! Dictionary<String, Any>
            let d = dict.mapValues({ JSON.parse(value: $0) })
            return JSON.parse(value: d)
        case is Array<Any>:
            let arr = (value as! Array<Any>).map({ JSON.parse(value: $0) })
            return JSON.parse(value:arr)
        case is Int:
            return JSON.intValue(value as! Int)
        case is String:
            return JSON.stringValue(value as! String)
        case is Bool:
            return JSON.boolValue(value as! Bool)
        case is Double:
            return JSON.doubleValue(value as! Double)
        default:
            return JSON.any(value)
        }
    }
}

extension JSON {
    public subscript(index: Int) -> JSON {
        if case .arrayValue(let arr) = self {
            guard index < arr.count else { return JSON.null }
            let value = arr[index]
            return JSON.any(value).jsonValue
        }
        if case .array(let arr) = self {
            guard index < arr.count else { return JSON.null }
            return arr[index]
        }
        return JSON.null
    }
    
    public subscript(key: String) -> JSON {
        if case .dictionaryValue(let dict) = self {
            guard let value = dict[key] else { return JSON.null }
            return JSON.any(value).jsonValue
        }
        if case .dictionary(let dict) = self {
            guard let value = dict[key] else { return JSON.null }
            return value
        }
        return JSON.null
    }
    
    public subscript(dynamicMember member: String) -> JSON {
        if case .dictionaryValue(let dict) = self {
            guard let value = dict[member] else { return JSON.null }
            return JSON.any(value).jsonValue
        }
        if case .dictionary(let dict) = self {
            guard let value = dict[member] else { return JSON.null }
            return value
        }
        return JSON.null
    }
}

extension JSON {
    public subscript<T: CanReformToJSONType>(index: Int) -> T {
        if case .arrayValue(let arr) = self {
            guard index < arr.count else { return T.init() }
            let value = arr[index]
            return (value as? T) ?? T.init()
        }
        if case .array(let arr) = self {
            guard index < arr.count else { return T.init() }
            guard let value = arr[index].value() as? T else { return T.init() }
            return value
        }
        return T.init()
    }
    
    public subscript<T: CanReformToJSONType>(key: String) -> T {
        if case .dictionaryValue(let dict) = self {
            guard let value = dict[key] else { return T.init() }
            return (value as? T) ?? T.init()
        }
        if case .dictionary(let dict) = self {
            guard let json = dict[key] else { return T.init() }
            guard let value = json.value() as? T else { return T.init() }
            return value
        }
        return T.init()
    }
    
    public subscript<T: CanReformToJSONType>(dynamicMember member: String) -> T {
        if case .dictionaryValue(let dict) = self {
            guard let value = dict[member] else { return T.init() }
            return (value as? T) ?? T.init()
        }
        if case .dictionary(let dict) = self {
            guard let json = dict[member] else { return T.init() }
            guard let value = json.value() as? T else { return T.init() }
            return value
        }
        return T.init()
    }
}

extension JSON {
    public func value() -> Any? {
        switch self {
        case .boolValue(let value):
            return value
        case .intValue(let value):
            return value
        case .stringValue(let value):
            return value
        case .doubleValue(let value):
            return value
        case .dataValue(let value):
            return value
        case .arrayValue(let value):
            return value
        case .dictionaryValue(let value):
            return value
        default:
            return nil
        }
    }
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
        case .dictionaryValue(let value):
            return value.toJSON()
        case .dictionary(_):
            return self
        case .arrayValue(let value):
            return value.toJSON()
        case .array(_):
            return self
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
    public var array: Array<JSON>? {
        if case .array(let value) = self {
            return value
        }
        if case .arrayValue(let value) = self {
            return JSON.parse(value: value).array
        }
        return nil
    }
    public var arrayValue: Array<JSON> {
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
    public var dictionary: Dictionary<String, JSON>? {
        if case .dictionary(let dict) = self {
            return dict
        }
        if case .dictionaryValue(let dict) = self {
            return JSON.parse(value: dict).dictionary
        }
        return nil
    }
    public var dictionaryValue: Dictionary<String, JSON> {
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
        return JSON.arrayValue(self)
    }
    
    public static func reformWith(json: JSON) -> Array<Element> {
        return json.arrayValue
    }
}

extension Dictionary: CanReformToJSONType where Value == Any, Key == String {
    public func toJSON() -> JSON {
        return JSON.dictionaryValue(self)
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
