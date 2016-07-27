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

    public static func insertIntoContext(moc: NSManagedObjectContext, order: Int, questionOrder: Int, quizId: String, text: String?, isCorrect: Bool?) -> Answer {
        let answer: Answer = moc.insertObject()
        
        answer.order = order
        
        let question: Question = Question.findOrCreateQuestion(quizId, order: questionOrder, inContext: moc)
        
        answer.question = question
        
        if let isCorrect = isCorrect {
            answer.isCorrect = isCorrect
        }
        
        if let text = text {
            answer.text = text
        }
        
        return answer
    }
    
    static func findOrCreateAnswer(quizId: String, questionOrder: Int, order: Int, inContext moc: NSManagedObjectContext) -> Answer {
        let question: Question = Question.findOrCreateQuestion(quizId, order: questionOrder, inContext: moc)
        
        let predicate = NSPredicate(format: "%K == %@ AND %K == %d", Keys.Question.rawValue, question, Keys.Order.rawValue, order)
        
        
        let answer: Answer = findOrCreateInContext(moc, matchingPredicate: predicate) {
            $0.order = order
        }
        
        return answer
    }
    
}

extension Answer: KeyCodable {
    public enum Keys: String {
        case Order = "order"
        case Text = "Text"
        case IsCorrect = "isCorrect"
        case Question = "question"
    }
}



extension Answer: ManagedObjectType {
    public static var entityName: String { return "Answer"}
}