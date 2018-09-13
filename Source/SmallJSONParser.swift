import Foundation

@dynamicMemberLookup
public enum JSON {
    case stringValue(String)
    case intValue(Int)
    case boolValue(Bool)
    case doubleValue(Double)
    case any(Any)
    case arrayValue(Array<JSON>)
    case dictionaryValue(Dictionary<String, JSON>)
    case null
    
    public static func parse(data: Data) -> JSON {
        return JSON.parse(data as Any)
    }
    
    public static func parse(string: String) -> JSON {
        return JSON.parse(data: string.data(using: .utf8) ?? Data())
    }
    
    fileprivate static func parse(_ value: Any) -> JSON {
        switch value {
        case is Dictionary<String, JSON>:
            return JSON.dictionaryValue(value as! Dictionary<String, JSON>)
        case is Array<JSON>:
            return JSON.arrayValue(value as! Array<JSON>)
        case is Data:
            if let dict = try? JSONSerialization.jsonObject(with: (value as! Data), options: []) as? Dictionary<String, Any> {
                return JSON.parse(dict as Any)
            }
            if let array = try? JSONSerialization.jsonObject(with: (value as! Data), options: []) as? Array<Any> {
                return JSON.parse(array as Any)
            }
            return JSON.any(value)
        case is Dictionary<String, Any>:
            let dict = value as! Dictionary<String, Any>
            let d = dict.mapValues({ JSON.parse($0) })
            return JSON.parse(d)
        case is Array<Any>:
            let arr = (value as! Array<Any>).map({ JSON.parse($0) })
            return JSON.parse(arr)
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
    
    public subscript(index: Int) -> JSON {
        if case .arrayValue(let arr) = self {
            return index < arr.count ? arr[index] : JSON.null
        }
        return JSON.null
    }
    
    public subscript(key: String) -> JSON {
        if case .dictionaryValue(let dict) = self {
            return dict[key] ?? JSON.null
        }
        return JSON.null
    }
    
    public subscript(dynamicMember member: String) -> JSON {
        if case .dictionaryValue(let dict) = self {
            return dict[member] ?? JSON.null
        }
        return JSON.null
    }
    
    public subscript<T: HaveInitMethod>(dynamicMember member: String) -> T {
        if case .dictionaryValue(let dict) = self {
            let json = dict[member] ?? JSON.null
            switch String(describing: T.self) {
            case String(describing: Int.self):
                return json.intValue as! T
            case String(describing: String.self):
                return json.stringValue as! T
            case String(describing: Double.self):
                return json.doubleValue as! T
            case String(describing: Bool.self):
                return json.boolValue as! T
            case String(describing: Date.self):
                if #available(iOS 10.0, tvOS 11.0, OSX 10.13, *) {
                    return json.dateValue as! T
                } else {
                    return json.stringValue as! T
                }
            default:
                return T.init()
            }
        }
        return T.init()
    }
    
    public subscript<T: HaveInitMethod>(index: Int) -> T {
        if case .arrayValue(let arr) = self {
            let json = index < arr.count ? arr[index] : JSON.null
            switch String(describing: T.self) {
            case String(describing: Int.self):
                return json.intValue as! T
            case String(describing: String.self):
                return json.stringValue as! T
            case String(describing: Double.self):
                return json.doubleValue as! T
            case String(describing: Bool.self):
                return json.boolValue as! T
            case String(describing: Date.self):
                if #available(iOS 10.0, tvOS 11.0, OSX 10.13, *) {
                    return json.dateValue as! T
                } else {
                    return json.stringValue as! T
                }
            default:
                return T.init()
            }
        }
        return T.init()
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
        return false
    }
    public var boolValue: Bool {
        return bool ?? false
    }
}

@available(iOS 10.0, tvOS 11.0, OSX 10.13, *)
extension JSON {
    public var date: Date? {
        if let str = string {
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: str) {
                return date
            }
            if #available(iOS 11.0, *) {
                formatter.formatOptions = [.withFractionalSeconds, .withInternetDateTime]
            } else {
                formatter.formatOptions = [.withInternetDateTime]
            }
            if let date = formatter.date(from: str) {
                return date
            }
        }
        return nil
    }
    public var dateValue: Date {
        return date ?? Date()
    }
}

extension JSON {
    public var array: Array<JSON>? {
        if case .arrayValue(let value) = self {
            return value
        }
        return nil
    }
    public var arrayValue: Array<JSON> {
        return array ?? []
    }
    
    public var dictionary: Dictionary<String, JSON>? {
        if case .dictionaryValue(let dict) = self {
            return dict
        }
        return nil
    }
    public var dictionaryValue: Dictionary<String, JSON> {
        return dictionary ?? [:]
    }
}

public protocol HaveInitMethod {
    init()
}

extension Int: HaveInitMethod { }
extension Double: HaveInitMethod { }
extension String: HaveInitMethod { }
extension Array: HaveInitMethod { }
extension Dictionary: HaveInitMethod { }
extension Bool: HaveInitMethod { }
extension Date: HaveInitMethod { }
