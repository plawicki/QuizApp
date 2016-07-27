//
//  CoreDataHelper.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import CoreData
import UIKit

public final class CoreDataHelper {
    public static func getManagedObjectContext() ->  NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
}