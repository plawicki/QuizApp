//
//  Quiz+CoreDataProperties.swift
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

extension Quiz {

    @NSManaged var id: String?
    @NSManaged var imageUrl: String?
    @NSManaged var numberOfQuestions: NSNumber
    @NSManaged var result: NSNumber?
    @NSManaged var title: String?
    @NSManaged var questions: NSSet?
    @NSManaged var correctAnswers: NSNumber?
    @NSManaged var lastQuestionOrderNumber: NSNumber?
}
