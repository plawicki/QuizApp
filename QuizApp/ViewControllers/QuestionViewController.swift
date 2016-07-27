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
    
    var currentQuestionNumber = 0
    var correctAnswers = 0
    var lastQuestion = 0
    
    var quiz: Quiz?
    var questions: Array<Question> = []
    var answers: Array<Answer> = []
    var currentQuestion: Question?
    
    init(quiz: Quiz) {
        super.init(nibName: nil, bundle: nil)
        
        self.quiz = quiz
        self.questions = (quiz.questions!.allObjects) as! [Question]
        self.correctAnswers = quiz.correctAnswers as! Int
        self.lastQuestion = quiz.lastQuestionOrderNumber as! Int
        
        questions.sortInPlace({Int($0.order) < Int($1.order)})
        
        self.currentQuestion = questions[self.lastQuestion]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func clickAnswer(sender: UIButton) {
        
    }
}
