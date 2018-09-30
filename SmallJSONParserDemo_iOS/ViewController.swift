//
//  ViewController.swift
//  SmallJSONParserDemo_iOS
//
//  Created by Benq on 2018/9/13.
//

import UIKit
import SmallJSONParser

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let request = URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                let json = JSON.parse(data)
                let id: Int = json.id
                let title: String = json.title
                let completed: Bool = json.completed
                print("id: \(id), \ntitle: \(title), \ncompleted: \(completed)")
            }
        }
        request.resume()
    }

}

