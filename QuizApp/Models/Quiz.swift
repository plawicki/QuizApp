//
//  Quiz.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation
import CoreData


public final class Quiz: ManagedObject {
    public static func insertIntoContext(moc: NSManagedObjectContext, id: String, title: String, numberOfQuestions: Int, result: Int?, imageUrl: String?, questions: Set<Question>?) -> Quiz {
        let quiz: Quiz = moc.insertObject()
        quiz.id = id
        quiz.title = title
        quiz.numberOfQuestions = numberOfQuestions
        
        if let result = result {
            quiz.result = result
        }
        
        if let image = imageUrl {
            quiz.imageUrl = image
        }
        
        if let questions = questions {
            quiz.questions = questions
        }
        
        return quiz
    }
    
    static func findOrCreateQuiz(id: String, inContext moc: NSManagedObjectContext) -> Quiz {
        
        let predicate = NSPredicate(format: "%K LIKE %@", Keys.Id.rawValue, id)
        
        
        let quiz: Quiz = findOrCreateInContext(moc, matchingPredicate: predicate) {
            $0.id = id
        }

        return quiz
    }
}

extension Quiz: KeyCodable {
    public enum Keys: String {
        case Id = "id"
        case ImageUrl = "imgageUrl"
        case NumberOfQuestion = "numberOfQuestions"
        case Result = "result"
        case Title = "title"
        case Questions = "Questions"
    }
}

extension Quiz: ManagedObjectType {
    public static var entityName: String { return "Quiz" }
}
