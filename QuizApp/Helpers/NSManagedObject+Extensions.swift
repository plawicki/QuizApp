//
//  NSManagedObject+Extensions.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import CoreData

public class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType where Self: ManagedObject {
    
    public static func findOrCreateInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self {
        guard let obj = fetchInContext(moc, matchingPredicate: predicate) else {
            let newObject: Self = moc.insertObject()
            configure(newObject)
            return newObject
        }
        
        return obj
    }
    
    public static func fetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        let request = NSFetchRequest(entityName: Self.entityName)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        guard let results = try! moc.executeFetchRequest(request) as? [Self] else { fatalError("NSManagedObject error, cannot fetch objects") }
        
        guard let result = results.first else {
            return nil
        }
        
        return result
    }
    
    public static func fetchAllInContext(moc: NSManagedObjectContext) -> [Self]? {
        let request = NSFetchRequest(entityName: Self.entityName)
        
        guard let results = try! moc.executeFetchRequest(request) as? [Self] else { fatalError("NSManagedObject error, cannot fetch objects") }
        
        return results
    }
    
    static func isEmpty(moc: NSManagedObjectContext) -> Bool {
        let objects = fetchAllInContext(moc)
        
        if let isEmpty = objects?.isEmpty {
            return isEmpty
        }
        
        return true
    }
}