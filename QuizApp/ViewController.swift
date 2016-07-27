//
//  ViewController.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let moc = CoreDataHelper.getManagedObjectContext()
        
        Quiz.insertIntoContext(moc, id: "1", title: "New Quiz", numberOfQuestions: 1, result: nil, imageUrl: nil, questions: nil)
        Question.insertIntoContext(moc, order: 0, text: "Do you like pancakes", quizId: "1", answers: nil)
        Answer.insertIntoContext(moc, order: 0, questionOrder: 0, quizId: "1", text: "YES!!!1", isCorrect: true)
        
        let request = NSFetchRequest(entityName: "Quiz")

        let results:NSArray? = try? moc.executeFetchRequest(request)
        
        print(results)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

