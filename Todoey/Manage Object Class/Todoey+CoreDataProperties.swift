//
//  Todoey+CoreDataProperties.swift
//  Todoey
//
//  Created by Admin on 2018-04-04.
//  Copyright © 2018 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Todoey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todoey> {
        return NSFetchRequest<Todoey>(entityName: "Todoey")
    }

    @NSManaged public var name: String?
    @NSManaged public var parrent: NSSet?

}

// MARK: Generated accessors for parrent
extension Todoey {

    @objc(addParrentObject:)
    @NSManaged public func addToParrent(_ value: TodoItem)

    @objc(removeParrentObject:)
    @NSManaged public func removeFromParrent(_ value: TodoItem)

    @objc(addParrent:)
    @NSManaged public func addToParrent(_ values: NSSet)

    @objc(removeParrent:)
    @NSManaged public func removeFromParrent(_ values: NSSet)

}
