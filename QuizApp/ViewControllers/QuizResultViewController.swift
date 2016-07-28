//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by ITK developer User on 28.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import UIKit

class QuizResultViewController: UIViewController {
    @IBOutlet weak var percentLabel: UILabel!
    
    var quizId: String?
    var result: Int?
    var numberOfQuestions: Int?
    
    override func viewDidLoad() {
        setPercentage()
    }
    
    private func setPercentage() {
        if let nominator = result, denominator = numberOfQuestions {
            let percent: Int = (nominator / denominator) * 100
            percentLabel.text = String(percent) +  "%"
        }
    }

    @IBAction func goToQuizTable(sender: AnyObject) {
    }
    @IBAction func solveQuizAgain(sender: AnyObject) {
    }
}
