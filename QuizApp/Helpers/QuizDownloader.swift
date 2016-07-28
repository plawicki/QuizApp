//
//  QuizDownloader.swift
//  QuizApp
//
//  Created by ITK developer User on 28.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation

public final class QuizDownloader {
    static let quizesUrl = "http://quiz.o2.pl/api/v1/quizzes/0/100"
    static let context = CoreDataHelper.getManagedObjectContext()

    static func startDownloadingQuizesIfNotExistsLocaly(callback: () -> Void) {
        let isDataEmpty = Quiz.isEmpty(context)
        
        if isDataEmpty {
            let url = NSURL(string: quizesUrl)
            let request = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    self.parseQuizesAndSave(data)
                } else {
                    print("QuizDownloader error, cannot get data from quizes url")
                }
                
                callback()
            }
        }
    }
    
    private static func parseQuizesAndSave(json: NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments)
            
            if let quizes = json["items"] as? [[String: AnyObject]] {
                for quiz in quizes {
                    Quiz.insertIntoContextFromJson(context, quiz: quiz)
                }
            }
            
            context.saveOrRollback()
        } catch {
            print("QuizDownloader error, cannot parse json with quizes")
        }
    }
    
    static func downloadQuizDataIfNotExistsLocaly(quizId: String, callback: () -> ()) {
        let isDataEmpty = Question.isEmpty(context)
        
        if isDataEmpty {
            let url = NSURL(string: getQuizUrl(quizId))
            let request = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    self.parseQuestionAndAnswersAndSave(data, quizId: quizId)
                } else {
                    print("QuizDownloader error, cannot get data from quiz url")
                }
                callback()
            }
        }
    }
    
    private static func getQuizUrl(quizId: String) -> String{
        return "http://quiz.o2.pl/api/v1/quiz/" + String(quizId) + "/0"
    }
    
    private static func parseQuestionAndAnswersAndSave(json: NSData, quizId: String) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments)
            
            if let questions = json["questions"] as? [[String: AnyObject]] {
                for question in questions {
                    Question.insertIntoContextFromJson(context, quizId: quizId, question: question)
                    parseAnswers(question, quizId: quizId)
                }
            }
            
            context.saveOrRollback()
        } catch { 
            print("QuizDownloader error, cannot parse json with quizes")
        }
    }
    
    private static func parseAnswers(question: [String: AnyObject], quizId: String) {
        if let questionOrder = question["order"] as? Int {
            if let answers = question["answers"] as? [[String:  AnyObject]] {
                for answer in answers {
                    Answer.insertIntoContextFromJson(context, quizId: quizId, questionOrder: questionOrder, answer: answer)
                }
            }
        }
    }
}