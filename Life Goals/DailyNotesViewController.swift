//
//  DailyNotesViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/14/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class DailyNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let fetchRequest : NSFetchRequest<DailyNote> = DailyNote.fetchRequest()
    
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultsController : NSFetchedResultsController<DailyNote> = {
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: DailyNoteObject.keys.dailyNote, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(0)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //tableView.reloadData()
}
    
    @IBAction func segmeted(_ sender: UISegmentedControl) {
        loadData(sender.selectedSegmentIndex)
    }
    
    func loadData(_ segment : Int){
        if segment == 0 {
            fetchRequest.predicate = NSPredicate(format : "done = false")
        }else {
            fetchRequest.predicate = NSPredicate(format: "done = true")
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = fetchedResultsController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyNotesCell") as! DailyNotesTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell : DailyNotesTableViewCell, indexPath : IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.noteLabel.text = item.dailyNote
        if item.done {
            cell.doneButton.setImage(UIImage.init(named: "checked"), for: .normal)
        }else {
            cell.doneButton.setImage(UIImage.init(named: "NotCheck"), for: .normal)
        }
        cell.doneButton.tag = indexPath.row
        cell.doneButton.addTarget(self, action: #selector(self.checkDone(_:)), for: .touchUpInside)
    }
    
    func checkDone(_ sender : UIButton) {
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let item = fetchedResultsController.object(at: indexPath as IndexPath)
        item.done = !item.done
        saveContext()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            context.delete(item)
            saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dailyNoteVC = storyboard?.instantiateViewController(withIdentifier: "dailyNoteViewController") as! DailyNoteViewController
        let item = fetchedResultsController.object(at: indexPath)
        dailyNoteVC.noteItem = item
        navigationController?.pushViewController(dailyNoteVC, animated: true)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .delete :
            
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case .update :
            if let indexPath = indexPath , let cell = tableView.cellForRow(at: indexPath) as? DailyNotesTableViewCell {
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
            
        case .move :
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }

    func saveContext() {
        CoreDataStackManager.SharedInstance().saveContext()
    }

}
