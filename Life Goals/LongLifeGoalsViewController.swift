//
//  LongLifeGoalsViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/22/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class LongLifeGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    let fetchRequest : NSFetchRequest<Goal> = Goal.fetchRequest()
    var indexPathArray = [IndexPath]()
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    
    lazy var fetchedResultsController : NSFetchedResultsController<Goal> = {
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: GoalObject.keys.createdDate, ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchedResultsController.delegate = self
        indexPathArray.removeAll()
        fetchData(segmentedControl.selectedSegmentIndex)
        let quoteItem = ConvenientClass.shareInstance().getRandomQuote()
        quoteLabel.text = quoteItem.quote
        authorLabel.text = "__" + quoteItem.author + "__"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        indexPathArray.removeAll()
        fetchData(sender.selectedSegmentIndex)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = fetchedResultsController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goalItem = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalItemCell") as! GoalsTableViewCell
        indexPathArray.append(indexPath)
        configureCell(cell: cell, goalItem: goalItem)
        return cell
    }
    
    func configureCell(cell : GoalsTableViewCell, goalItem : Goal){
        cell.goalLabel.text = goalItem.goal
        if let photo = goalItem.photo {
            cell.photo.image = ImageCache.sharedInstance().getImageWithIdentifier(photo)
        } else {
            cell.photo.image = UIImage.init(named: "LogoIcon50")
        }
        let userCalendar = NSCalendar.current
        let createdDate = goalItem.createdDate as! Date
        let expriedDate = goalItem.expiredDate as! Date
        let currentDate = Date()
        let daysBetweenExpired = userCalendar.dateComponents([.day], from: createdDate, to: expriedDate)
        let daysBetweenCurrent = userCalendar.dateComponents([.day], from: createdDate, to: currentDate)
        if daysBetweenCurrent.day!  <= daysBetweenExpired.day! {
            cell.progessLabel.text = "\(daysBetweenCurrent.day!) / \(daysBetweenExpired.day!)"
            if daysBetweenExpired.day! > 0 {
                cell.progessView.setProgress(Float(daysBetweenCurrent.day!/daysBetweenExpired.day!), animated: true)
            } else {
                cell.progessView.setProgress(1, animated: true)
            }
        } else {
            cell.progessLabel.text = "\(daysBetweenExpired.day!) / \(daysBetweenExpired.day!)"
            cell.progessView.setProgress(1, animated: true)
        }
        cell.doneLabel.addTarget(self, action: #selector(self.setDoneSegue(_sender:)), for: .touchUpInside)
        cell.doneLabel.tag = indexPathArray.count - 1
        
        if goalItem.done {
            cell.doneLabel.setImage(UIImage.init(named: "checked"), for: .normal)
            if goalItem.doneDate == nil {
                cell.doneLabel.setImage(UIImage.init(named: "ExpiredDone"), for: .normal)
                cell.progessLabel.text = "Expired"
            }else {
                let doneDate = goalItem.doneDate as! Date
                cell.progessLabel.text = "Achived at \(doneDate.formatDateToString())"
            }
        } else {
            cell.doneLabel.setImage(UIImage.init(named: "NotCheck"), for: .normal)
        }
        
        cell.moreButton.addTarget(self, action: #selector(self.setAddNoteSegue(_:)), for: .touchUpInside)
        cell.moreButton.tag = indexPathArray.count - 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        let goalViewController = storyboard?.instantiateViewController(withIdentifier: "goalViewController") as! GoalViewController
        goalViewController.goalItem = item
        _ = navigationController?.pushViewController(goalViewController, animated: true)
        
    }
    
    //segue to add Notes View Controller
    func setAddNoteSegue(_ sender : UIButton) {
        let item = fetchedResultsController.object(at: indexPathArray[sender.tag])
        let notesVC = storyboard?.instantiateViewController(withIdentifier: "notesViewController") as! NotesViewController
        notesVC.goalItem = item
        _ = self.present(notesVC, animated: true, completion: nil)
    }
    
    //segue to done View Controller
    func setDoneSegue(_sender : UIButton) {
        let doneVC = self.storyboard?.instantiateViewController(withIdentifier: "doneViewController") as! DoneViewController
        let goal = fetchedResultsController.object(at: indexPathArray[_sender.tag])
        doneVC.goalItem = goal
        // _ = self.present(doneVC, animated: true, completion: nil)
        let _ = navigationController?.pushViewController(doneVC, animated: true)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //prepare segue to set this long term goal
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "longTermGoalSegue" {
            let goalVC = segue.destination as! GoalViewController
            goalVC.shortTerm = false
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newPath = newIndexPath {
                tableView.insertRows(at: [newPath], with: .fade)
                indexPathArray.append(newPath)
                print("Number of array :\(indexPathArray.count)")
                break
            }
        case .delete :
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
                print("only delete")
                tableView.reloadData()
                break
            }
        case .update:
            tableView.reloadData()
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .left)
            }
            print("do move")
            break;
        }
    }
    
    func saveContext() {
        CoreDataStackManager.SharedInstance().saveContext()
    }
    
    func fetchData(_ segmented : Int) {
        if segmented == 0 {
            fetchRequest.predicate = NSPredicate(format: "(shortTerm = false) AND (done == false)")
        } else {
            fetchRequest.predicate = NSPredicate(format: "(shortTerm = false) AND (done == true)")
        }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }   
  
}
