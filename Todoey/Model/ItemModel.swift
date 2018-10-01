//
//  Model.swift
//  Todoey
//
//  Created by Roderick Presswood on 9/19/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import Foundation

//object properties title: String done: bool
class Item: Codable {
    var title: String = ""
    var done: Bool = false
    
//    init(title: String, done: Bool) {
//        self.title = title
//        self.done = done
//    }
}
