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
    
    var quizId: String?
    var quiz: Quiz?
    
    var currentQuestionNumber = 0
    var correctAnswers = 0
    var numberOfQuestions = 0
    
    var questions: Array<Question> = []
    var answers: Array<Answer> = []
    var currentQuestion: Question?
    
    override func viewDidLoad() {
        setupVariables()
        updateUIForQuestion()
    }
    
    private func setupVariables() {
        guard let id = quizId else {
            print("QuestionViewController error, quizId is not provided")
            return
        }
        
        quiz = Quiz.findOrCreateQuiz(id, inContext: context)
        
        if let quiz = quiz {
            currentQuestionNumber = (quiz.lastQuestionOrderNumber?.integerValue)!
            questions = quiz.questions!.allObjects as! [Question]
            currentQuestion = questions[currentQuestionNumber]
            numberOfQuestions = quiz.numberOfQuestions.integerValue
            questions.sortInPlace({Int($0.order) < Int($1.order)})
            answers = (currentQuestion!.answers?.allObjects) as! [Answer]
            answers.sortInPlace({Int($0.order) < Int($1.order)})
        }
    }
    
    @IBAction func clickAnswer(sender: UIButton) {
        let answerNumber = sender.tag
        
        if answers[answerNumber].isCorrect.boolValue {
            correctAnswers += 1
        }
        
        self.currentQuestionNumber += 1
        
        if self.currentQuestionNumber < numberOfQuestions {
            updateUIForQuestion()
        } else {
            print("koniec")
        }
    }
    
    private func updateUIForQuestion() {
        self.currentQuestion = questions[currentQuestionNumber]

        self.questionLabel.text = self.currentQuestion?.text
        
        answers = (currentQuestion!.answers?.allObjects) as! [Answer]
        answers.sortInPlace({Int($0.order) < Int($1.order)})
        
        self.answer1.setTitle(answers[0].text, forState: UIControlState.Normal)
        self.answer2.setTitle(answers[1].text, forState: UIControlState.Normal)
        
        if answers.count > 2 {
            self.answer3.setTitle(answers[2].text, forState: UIControlState.Normal)
            self.answer4.setTitle(answers[3].text, forState: UIControlState.Normal)
        } else {
            self.answer3.setTitle("", forState: UIControlState.Normal)
            self.answer4.setTitle("", forState: UIControlState.Normal)
        }
            
        saveQuizStatus()
    }
    
    private func saveQuizStatus() {
        quiz?.result = correctAnswers
        quiz?.lastQuestionOrderNumber = currentQuestion?.order
        
        if (currentQuestion?.order.intValue)! == (quiz?.numberOfQuestions.intValue)! {
            quiz?.lastQuestionOrderNumber = 0
        }
        
        context.saveOrRollback()
    }
}
