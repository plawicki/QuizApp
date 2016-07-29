//
//  TableToQuestionSegue.swift
//  QuizApp
//
//  Created by ITK developer User on 29.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import Foundation
import UIKit

class TableToQuestionSegue: UIStoryboardSegue {
    override func perform() {
        let src: QuizesTableViewController = self.sourceViewController as! QuizesTableViewController
        let dst = self.destinationViewController as! QuestionViewController
        
        QuizDownloader.downloadQuizDataIfNotExistsLocaly(src.getClickedQuiz().id) {
            src.navigationController?.pushViewController(dst, animated: true)
        }
    }
}
