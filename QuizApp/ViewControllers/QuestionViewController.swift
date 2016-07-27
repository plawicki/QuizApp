//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import UIKit
import CoreData

class QuestionViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    let context: NSManagedObjectContext = CoreDataHelper.getManagedObjectContext()
    
    var quiz: Quiz?
    
    var currentQuestionNumber = 0
    var correctAnswers = 0
    var numberOfQuestions = 0
    
    var questions: Array<Question> = []
    var answers: Array<Answer> = []
    var currentQuestion: Question?
    
    override func viewDidLoad() {
        self.currentQuestionNumber = (quiz!.lastQuestionOrderNumber?.integerValue)!
        self.questions = (quiz!.questions!.allObjects) as! [Question]
        self.currentQuestion = questions[self.currentQuestionNumber]
        self.correctAnswers = quiz!.correctAnswers as! Int
        
        self.numberOfQuestions = (quiz?.numberOfQuestions.integerValue)!

        questions.sortInPlace({Int($0.order) < Int($1.order)})
        
        self.answers = (currentQuestion!.answers?.allObjects) as! [Answer]
        
        answers.sortInPlace({Int($0.order) < Int($1.order)})
        
        updateQuestion()
    }
    
    @IBAction func clickAnswer(sender: UIButton) {
        let answerNumber = sender.tag
        
        if let correct = answers[answerNumber].isCorrect {
            if correct.boolValue { self.correctAnswers += 1 }
        }
        
        self.currentQuestionNumber += 1
        
        if self.currentQuestionNumber < self.numberOfQuestions {
            updateQuestion()
        } else {
            print("koniec")
        }
    }
    
    private func updateQuestion() {
        self.currentQuestion = questions[self.currentQuestionNumber]

        self.questionLabel.text = self.currentQuestion?.text
        self.answer1.setTitle(answers[0].text, forState: UIControlState.Normal)
        self.answer2.setTitle(answers[1].text, forState: UIControlState.Normal)
        self.answer3.setTitle(answers[2].text, forState: UIControlState.Normal)
        self.answer4.setTitle(answers[3].text, forState: UIControlState.Normal)
        
        saveQuizStatus()
    }
    
    private func saveQuizStatus() {
        quiz?.result = correctAnswers
        quiz?.lastQuestionOrderNumber = currentQuestion?.order
        
        if (currentQuestion?.order.intValue)! == ((quiz?.numberOfQuestions.intValue)! - 1) {
            quiz?.lastQuestionOrderNumber = 0
        }
        
        context.saveOrRollback()
    }
}
