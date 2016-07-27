//
//  CoreDataHelper.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import CoreData
import UIKit



extension NSManagedObjectContext {

    public func insertObject<A: NSManagedObject where A: ManagedObjectType>() -> A {
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else { fatalError("NSManagedObjectContext error, improper object type") }
        return obj
}

}

public class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    var managedObjectContext: NSManagedObjectContext? { get }
}

public protocol KeyCodable {
    typealias Keys: RawRepresentable
}

extension KeyCodable where Self: ManagedObject, Keys.RawValue == String {
    public func willAccessValueForKey(key: Keys) {
        willAccessValueForKey(key.rawValue)
    }
    
    public func didAccessValueForKey(key: Keys) {
        didAccessValueForKey(key.rawValue)
    }
    
    public func willChangeValueForKey(key: Keys) {
        (self as NSManagedObject).willChangeValueForKey(key.rawValue)
    }
    
    public func didChangeValueForKey(key: Keys) {
        (self as NSManagedObject).didChangeValueForKey(key.rawValue)
    }
    
    public func valueForKey(key: Keys) -> AnyObject? {
        return (self as NSManagedObject).valueForKey(key.rawValue)
    }
    
    public func mutableSetValueForKey(key: Keys) -> NSMutableSet {
        return mutableSetValueForKey(key.rawValue)
    }
    
    public func changedValueForKey(key: Keys) -> AnyObject? {
        return changedValues()[key.rawValue]
    }
    
    public func committedValueForKey(key: Keys) -> AnyObject? {
        return committedValuesForKeys([key.rawValue])[key.rawValue]
    }
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
}