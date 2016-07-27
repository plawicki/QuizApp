//
//  NSManagedObjectContext+Extensions.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    public func insertObject<A: NSManagedObject where A: ManagedObjectType>() -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else { fatalError("NSManagedObjectContext error, improper object type") }
        return obj
    }
}