//
//  Question.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation
import CoreData

public final class Question: ManagedObject {

    public static func insertIntoContext(moc: NSManagedObjectContext, order: Int, text: String?, quizId: Int?, answers: Set<Answer>?) -> Question {
        let question: Question = moc.insertObject()
        question.order = order
        
        if let text = text {
            question.text = text
        }
        
        if let quiz = quizId {
            question.quiz = Quiz.findOrCreateQuiz(quiz, inContext: moc)
        }
        
        if let answers = answers {
            question.answers = answers
        }
        
        return question
    }
    
    static func findOrCreateQuestion(quizId: Int, order: Int, inContext moc: NSManagedObjectContext) -> Question {
        let quiz: Quiz = Quiz.findOrCreateQuiz(quizId, inContext: moc)
        
        let predicate = NSPredicate(format: "%K == %@ AND %K == %d", Keys.Quiz.rawValue, quiz, Keys.Order.rawValue, order)
        
        
        let question: Question = findOrCreateInContext(moc, matchingPredicate: predicate) {
            $0.order = order
        }
        
        return question
    }

}

extension Question: KeyCodable {
    public enum Keys: String {
        case Order = "order"
        case Text = "text"
        case Answers = "answers"
        case Quiz = "quiz"
    }
}

extension Question: ManagedObjectType {
    public static var entityName: String { return "Question"}
}