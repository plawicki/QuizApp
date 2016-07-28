//
//  Answer.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation
import CoreData

public final class Answer: ManagedObject {

    public static func insertIntoContext(moc: NSManagedObjectContext, order: Int, questionOrder: Int, quizId: String, isCorrect: Bool, text: String) -> Answer {
        let answer: Answer = moc.insertObject()
        answer.order = order
        
        let question: Question = Question.findOrCreateQuestion(quizId, order: questionOrder, inContext: moc)
        
        answer.question = question
        answer.isCorrect = isCorrect
        answer.text = text
        
        return answer
    }
    
    static func findOrCreateAnswer(quizId: String, questionOrder: Int, order: Int, inContext moc: NSManagedObjectContext) -> Answer {
        let question: Question = Question.findOrCreateQuestion(quizId, order: questionOrder, inContext: moc)
        
        let predicate = NSPredicate(format: "%K == %@ AND %K == %d", Keys.Question.rawValue, question, Keys.Order.rawValue, order)
        
        
        let answer: Answer = findOrCreateInContext(moc, matchingPredicate: predicate) {
            $0.order = order
            let question: Question = Question.findOrCreateQuestion(quizId, order: questionOrder, inContext: moc)
            $0.question = question
        }
        
        return answer
    }
    
    static func insertIntoContextFromJson(moc: NSManagedObjectContext, quizId: String, questionOrder: Int, answer: [String: AnyObject]) {
        let orderFromJson: Int? = answer["order"] as? Int
        let text: String? = answer["text"] as? String
        let isCorrect: Bool? = answer["isCorrect"] as? Bool
        
        guard let order = orderFromJson else {
            print("Answer error, cannot find order number of answer")
            return
        }
        
        let answer = findOrCreateAnswer(quizId, questionOrder: questionOrder, order: order, inContext: moc)
        
        if let isCorrect = isCorrect {
            answer.isCorrect = isCorrect
        } else {
            answer.isCorrect = false
        }
        
        if let text = text {
            answer.text = text
        }
    }
}

extension Answer: KeyCodable {
    public enum Keys: String {
        case Order = "order"
        case Text = "text"
        case IsCorrect = "isCorrect"
        case Question = "question"
    }
}



extension Answer: ManagedObjectType {
    public static var entityName: String { return "Answer"}
}