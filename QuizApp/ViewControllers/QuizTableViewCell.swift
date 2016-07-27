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
        
        if let result = quiz.result {
            self.setResult(result, numberOfQuestions: quiz.numberOfQuestions)
        }
    }
    
    private func setResult(result: NSNumber, numberOfQuestions: NSNumber)  {
        quizResult.text = "Last result: " + result.stringValue + "/" + numberOfQuestions.stringValue
    }
}

extension  QuizTableViewCell {
    static var quizTableViewCellIdentifier: String { return "quizCell" }
}