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

}
