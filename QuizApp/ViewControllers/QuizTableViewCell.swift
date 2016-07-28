//
//  QuizTableViewCell.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    @IBOutlet weak var quizTitle: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var quizResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension QuizTableViewCell: ConfigurableCell {
    func configureForObject(quiz: Quiz) {
        
        quizTitle.text = quiz.title
        
        if let imgUrl = quiz.imageUrl {
            quizImage.imageFromUrl(imgUrl)
        }
        
        self.setResult(quiz.result, numberOfQuestions: quiz.numberOfQuestions, lastQuestionNumber: quiz.lastQuestionOrderNumber)
    }
    
    private func setResult(result: NSNumber, numberOfQuestions: NSNumber, lastQuestionNumber: NSNumber?)  {
        var labelText = "Last result: " + result.stringValue + "/" + numberOfQuestions.stringValue
        
        if let done: NSNumber = lastQuestionNumber where done.intValue < numberOfQuestions.intValue {
            let donePercent: Int = (done.integerValue / numberOfQuestions.integerValue) * 100
            labelText += " " + String(donePercent)
        }
        
        quizResult.text = labelText
    }
}

extension  QuizTableViewCell {
    static var quizTableViewCellIdentifier: String { return "quizCell" }
}