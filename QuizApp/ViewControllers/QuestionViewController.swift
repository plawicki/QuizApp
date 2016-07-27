//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    var currentQuestion = 0
    var correctAnswers = 0
    var questionId: Question?
    var answers: Set<Answer>?
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func clickAnswer(sender: UIButton) {
        
    }
}
