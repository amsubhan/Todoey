//
//  Item.swift
//  Todoey
//
//  Created by Admin on 2018-04-12.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
//    @objc dynamic var date : String = ""
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "itemsObjects") //points back towards items of Item.swift
}
