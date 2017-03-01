//
//  ShortLifeGoalsViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/21/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class ShortLifeGoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!     
    @IBOutlet weak var tableView: UITableView!
    
    var indexPathArray = [IndexPath]()
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
   
  //  let fetchRequest : NSFetchRequest<GoalObject> = GoalObject.fetchRequest() as! NSFetchRequest<GoalObject>
    
    lazy var fetchedResultsController : NSFetchedResultsController<Goal> = {
        let fetchRequest : NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: GoalObject.keys.createdDate, ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()

   
    override func viewDidLoad() {
        super.viewDidLoad()
     //   addButton.title = ""
       // addButton.setBackgroundImage(UIImage.init(named: "AddIcon"), for: .normal, barMetrics: .default)
       // addButton.frame = CGRectMake(0, 0, 30.0, 30.0)
        // Do any additional setup after loading the view.
      //  fetchData(segmentedControl.selectedSegmentIndex)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
       // tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        fetchData(sender.selectedSegmentIndex)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = fetchedResultsController.sections![section]
        return sessionInfo.numberOfObjects
       // return 0
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
        cell.photo.image = ImageCache.sharedInstance().getImageWithIdentifier(goalItem.photo)
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
    }
    
    func setDoneSegue(_sender : UIButton) {
        let doneVC = self.storyboard?.instantiateViewController(withIdentifier: "doneViewController") as! DoneViewController
        let goal = fetchedResultsController.object(at: indexPathArray[_sender.tag])
        doneVC.goalItem = goal
        print(_sender.tag)
        let _ = navigationController?.pushViewController(doneVC, animated: true)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newPath = newIndexPath {
                tableView.insertRows(at: [newPath], with: .fade)
            }
        default:
            return
        }
    }
    
    func saveContext() {
        CoreDataStackManager.SharedInstance().saveContext()
    }
    
    func fetchData(_ segmented : Int) {
//        if segmented == 0 {
//            fetchRequest.predicate = NSPredicate(format: "done == false")
//        } else {
//            fetchRequest.predicate = NSPredicate(format: "done == true")
//        }
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            print(error)
//        }
//        tableView.reloadData()
    }
}
