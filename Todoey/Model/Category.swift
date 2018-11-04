//
//  Category.swift
//  Todoey
//
//  Created by Roderick Presswood on 10/4/18.
//  Copyright © 2018 Roderick Presswood. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    
}
