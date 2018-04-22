//
//  Category.swift
//  Todoey
//
//  Created by Admin on 2018-04-12.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var bgColor : String = ""

    
    let itemsObjects = List<Item>()
}
