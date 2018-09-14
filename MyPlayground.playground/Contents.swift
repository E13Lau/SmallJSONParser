import Cocoa
import SmallJSONParser
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
let request = URLSession.shared.dataTask(with: url) { (data, _, _) in
    if let data = data {
        let startP = CACurrentMediaTime()
        let json = JSON.any(data).jsonValue
        let endP = CACurrentMediaTime()
        print("\(endP - startP)")
        let id: Int = json.id
        let title: String = json.title
        let completed: Bool = json.completed
        print("id: \(id), \ntitle: \(title), \ncompleted: \(completed)")
    }
}
request.resume()

let filePath = Bundle.main.path(forResource: "example", ofType: "json")!
let contentData = FileManager.default.contents(atPath: filePath)!
let content = String(data: contentData, encoding: .utf8)!

let start = CACurrentMediaTime()
//let json = JSON.any(example).json
let json = JSON.any(content).jsonValue
let end = CACurrentMediaTime()
print("\(end - start)")
let name: String = json.name
let mainString: String = json.weather[1].main
let mainInt: Int = json.weather[1].main
let base = json.base
let baseInt: Int = json.base
let e: Array<Any> = json.base
let isAdmin: Bool = json.isAdmin
let isAdminString: String = json.isAdmin
let isAdminJSON = json.isAdmin
let updateDate: Date = json.updatedAt
let createDate: Date = json.createAt
let updateDateString: String = json.updatedAt
json.name
json.isAdmin.bool
json.main.wind.deg.intValue
json.main.stringValue



//let example2Path = Bundle.main.path(forResource: "example2", ofType: "json")!
//let example2Data = FileManager.default.contents(atPath: example2Path)!
//let otherstart = CACurrentMediaTime()
//let j = JSON.dataValue(example2Data).json
//let otherend = CACurrentMediaTime()
//print("\(otherend - otherstart)")

if let dict = try JSONSerialization.jsonObject(with: (contentData), options: []) as? Dictionary<String, Any> {
    let s = CACurrentMediaTime()
    let jjj = JSON.dictionary(dict)
    let e = CACurrentMediaTime()
    print("\(e - s)")
    jjj.name
    let name = jjj.name.stringValue
    let wind = jjj.main.wind.deg.intValue
    let ss = CACurrentMediaTime()
    jjj.main.wind.deg.intValue
    let ee = CACurrentMediaTime()
    print("\(Double(ee - ss))")
}
