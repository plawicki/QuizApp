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
    public static func insertIntoContext(moc: NSManagedObjectContext, id: String, title: String, numberOfQuestions: Int, result: Int, lastQuestionOrderNumber: Int, imageUrl: String?, questions: Set<Question>?) -> Quiz {
        let quiz: Quiz = moc.insertObject()
        quiz.id = id
        quiz.title = title
        quiz.numberOfQuestions = numberOfQuestions
        quiz.result = result
        quiz.lastQuestionOrderNumber = lastQuestionOrderNumber
        
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
    
    static func insertIntoContextFromJson(moc: NSManagedObjectContext, quiz: [String: AnyObject]) {
        let idFromJson: NSNumber? = quiz["id"] as? NSNumber
        let title: String? = quiz["title"] as? String
        let numberOfQuestions: Int? = quiz["questions"] as? Int
        let photo: [String: AnyObject]? = quiz["mainPhoto"] as? [String: AnyObject]
        var imgUrl: String?
        
        if let photoJson = photo {
            imgUrl = photoJson["url"] as? String
        }
        
        guard let id: String = String(idFromJson) else {
            print("Quiz error, cannot find id of quiz")
            return
        }
        
        let quiz = findOrCreateQuiz(id, inContext: moc)
        
        if let title = title {
            quiz.title = title
        }
        
        if let questions = numberOfQuestions {
            quiz.numberOfQuestions = questions
        }
        
        if let img = imgUrl {
            quiz.imageUrl = img
        }
        
        quiz.result = 0
        quiz.lastQuestionOrderNumber = 0
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
