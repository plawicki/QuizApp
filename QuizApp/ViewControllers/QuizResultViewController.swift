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
            let percent: Int = Int((Float(nominator) / Float(denominator)) * 100)
            percentLabel.text = String(percent) +  "%"
        }
    }

    @IBAction func goToQuizTable(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func solveQuizAgain(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResultToQuestionSegue" {
            let destinationVC: QuestionViewController = segue.destinationViewController as! QuestionViewController
            destinationVC.quizId = quizId
        }
    }
}
