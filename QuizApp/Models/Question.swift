//
//  Question.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation
import CoreData


public final class Question: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}


extension Question: ManagedObjectType {
    public static var entityName: String { return "Question "}
}