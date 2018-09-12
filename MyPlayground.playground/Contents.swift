import Cocoa
import SmallJSONParser

let example =
"""
{
"isAdmin": true,
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
let name: String = json.name
let mainString: String = json.weather[1].main
let mainInt: Int = json.weather[1].main
let base = json.base
let baseInt: Int = json.base
let e: Array<String> = json.base
let isAdmin: Bool = json.isAdmin
let isAdminString: String = json.isAdmin
let isAdminJSON = json.isAdmin
json.name
