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
    public static func insertIntoContext(moc: NSManagedObjectContext, id: String, title: String, numberOfQuestions: Int, result: Int?, imageUrl: String?, questions: Set<Question>?, correctAnswers: Int?, lastQuestionOrderNumber: Int?) -> Quiz {
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
        
        if let correctAnswers = correctAnswers {
            quiz.correctAnswers = correctAnswers
        }
        
        if let lastQuestionOrderNumber = lastQuestionOrderNumber {
            quiz.lastQuestionOrderNumber = lastQuestionOrderNumber
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
    
    static func getFetchRequest(moc:  NSManagedObjectContext) ->  NSFetchRequest {
        let quizFetchRequest = NSFetchRequest(entityName: self.entityName)
        let sortDescriptor = NSSortDescriptor(key: Keys.Result.rawValue, ascending: false)
        quizFetchRequest.sortDescriptors = [sortDescriptor]
        
        return quizFetchRequest
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
