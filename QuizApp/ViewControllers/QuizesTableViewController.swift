//
//  QuizesTableViewController.swift
//  QuizApp
//
//  Created by ITK developer User on 26.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import UIKit
import CoreData

class QuizesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let context: NSManagedObjectContext! = CoreDataHelper.getManagedObjectContext()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = Quiz.getFetchRequest(self.context)
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("QuizesTableViewController error, cannot perform fetch")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "quizCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let quiz = fetchedResultsController.objectAtIndexPath(indexPath) as! Quiz

        self.setupCell(&cell, quiz: quiz)
        
        return cell
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
        case .Delete:
            if let deleteIndexPath = indexPath {
                    self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        case .Move:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        case .Update:
            if let updateIndexPath = indexPath {
                var cell = self.tableView.cellForRowAtIndexPath(updateIndexPath)
                let quiz: Quiz = self.fetchedResultsController.objectAtIndexPath(updateIndexPath) as! Quiz
                
                if cell != nil {
                    self.setupCell(&cell!, quiz: quiz)
                }
            }
        }
    }
    
    private func setupCell(inout cell: UITableViewCell, quiz: Quiz) {
        let titleLabel: UILabel = cell.viewWithTag(101) as! UILabel
        let quizImageView: UIImageView = cell.viewWithTag(100) as! UIImageView
        let resultLabel: UILabel = cell.viewWithTag(102) as! UILabel
        
        titleLabel.text = quiz.title
        
        if let imgUrl = quiz.imageUrl {
            quizImageView.imageFromUrl(imgUrl)
        }
        
        if let quizResult = quiz.result {
            resultLabel.text = quizResult.stringValue
        }
    }
    

    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
