//
//  TodoItem+CoreDataProperties.swift
//  Todoey
//
//  Created by Admin on 2018-04-04.
//  Copyright © 2018 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var parrentCategory: Todoey?

}
