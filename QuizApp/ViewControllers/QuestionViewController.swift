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
    
    /*
    override func viewDidLoad() {
        setupVariables()
        updateUIForQuestion()
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            numberOfQuestions = quiz.numberOfQuestions.integerValue
            questions.sortInPlace({Int($0.order) < Int($1.order)})
            
            setupQuestionAndAnswers()
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
            goToResults()
        }
    }
    
    private func updateUIForQuestion() {
        setupQuestionAndAnswers()

        questionLabel.text = self.currentQuestion?.text
        
        answer1.setTitle(answers[0].text, forState: UIControlState.Normal)
        answer2.setTitle(answers[1].text, forState: UIControlState.Normal)
        
        // Sometimes, questions have only two or three answers, so we hiding other buttons
        if answers.count > 2 {
            answer3.setTitle(answers[2].text, forState: UIControlState.Normal)
            answer3.hidden = false
        } else {
            answer3.hidden = true
        }
        
        if answers.count > 3 {
            answer4.setTitle(answers[3].text, forState: UIControlState.Normal)
            answer4.hidden = false
        } else {
            answer4.hidden = true
        }
        
        updateProgressBar()
        
        saveQuizStatus()
    }
    
    private func setupQuestionAndAnswers() {
        currentQuestion = questions[currentQuestionNumber]
        answers = (currentQuestion!.answers?.allObjects) as! [Answer]
        answers.sortInPlace({Int($0.order) < Int($1.order)})
    }
    
    private func updateProgressBar() {
        self.progressBar.progress = countProgress()
    }
    
    private func countProgress() -> Float {
        return Float(currentQuestionNumber) / Float(numberOfQuestions)
    }
    
    private func goToResults() {
        saveQuizStatus()
        performSegueWithIdentifier("QuestionToResultSegue", sender: self)
    }
    
    private func saveQuizStatus() {
        if let quiz = quiz, question = currentQuestion {
            quiz.result = correctAnswers
            quiz.lastQuestionOrderNumber = currentQuestion?.order
            
            if question.order.intValue == quiz.numberOfQuestions.intValue {
                quiz.lastQuestionOrderNumber = 0
            }
            
            context.saveOrRollback()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC: QuizResultViewController = segue.destinationViewController as! QuizResultViewController
        destinationVC.quizId = quizId
        destinationVC.result = quiz?.result.integerValue
        destinationVC.numberOfQuestions = numberOfQuestions
    }
}
