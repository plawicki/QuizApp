//
//  Question+CoreDataProperties.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var order: NSNumber?
    @NSManaged var text: String?
    @NSManaged var answers: NSSet?
    @NSManaged var quiz: Quiz?

}
