//
//  QuizDownloader.swift
//  QuizApp
//
//  Created by ITK developer User on 28.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation

public final class QuizDownloader {
    let quizesUrl = "http://quiz.o2.pl/api/v1/quizzes/0/100"
    let context = CoreDataHelper.getManagedObjectContext()

    func startDownloadingQuizesIfNotExistsLocaly(callback: () -> ()) {
        let isDataEmpty = Quiz.isEmpty(context)
        
        if isDataEmpty {
            let url = NSURL(string: quizesUrl)
            let request = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
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
    
    private func parseQuizesAndSave(json: NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments)
            
            if let quizes = json["items"] as? [[String: AnyObject]] {
                for quiz in quizes {
                    Quiz.insertIntoContextFromJson(context, quiz)
                }
            }
            
            context.saveOrRollback()
        } catch {
            print("QuizDownloader error, cannot parse json with quizes")
        }
    }
    
    func downloadQuizDataIfNotExistsLocaly(quizId: String, callback: () -> ()) {
        let isDataEmpty = Question.isEmpty()
        
        if isDataEmpty {
            let url = NSURL(string: getQuizUrl(quizId))
            let request = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    self.parseQuestionAndAnswersAndSave(data)
                } else {
                    print("QuizDownloader error, cannot get data from quiz url")
                }
                callback()
            }
        }
    }
    
    private func getQuizUrl(quizId: String) -> String{
        return "http://quiz.o2.pl/api/v1/quiz/" + quizId + "/0"
    }
    
    private func parseQuestionAndAnswersAndSave(json: NSData) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments)
            
            if let questions = json["questions"] as? [[String: AnyObject]] {
                for question in questions {
                    Question.insertIntoContextFromJson(context, question)
                    parseAnswers(question)
                }
            }
            
            context.saveOrRollback()
        } catch { 
            print("QuizDownloader error, cannot parse json with quizes")
        }
    }
    
    private func parseAnswers(answers: [String: AnyObject]) {
        if let answers = answers["answers"] as? [[String:  AnyObject]] {
            for answer in answers {
                Answer.insertIntoContextFromJson(context, answer)
            }
        }
    }
}