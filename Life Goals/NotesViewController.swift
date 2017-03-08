//
//  NotesViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/6/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var goalItem : Goal?
    var expiredDate : Date?
    var indexPathArray = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        indexPathArray.removeAll()
        //fetch data
        do{
            try fetchedResultController.performFetch()
        } catch{
            print (error)
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout(){
        if let goalItem = goalItem {
            if goalItem.shortTerm {
                termLabel.text = "Short term"
            }else {
                termLabel.text = "Long term"
            }
        
        
        expiredDate = goalItem.expiredDate as? Date
        expiredLabel.text = "Expired : \(expiredDate!.formatDateToString())"
        
        if goalItem.done {
            doneLabel.text = "Done"
        } else {
            doneLabel.text = "Not Done"
        }
        
        photo.image = ImageCache.sharedInstance().getImageWithIdentifier(goalItem.photo)
        
        goalLabel.text = goalItem.goal
        goalDescriptionLabel.text = goalItem.goalDescription
            
        fetchedResultController.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNoteSegue" {
            let noteVC = segue.destination as! NoteViewController
            noteVC.goalItem = self.goalItem
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = fetchedResultController.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell") as! NotesTableViewCell
        indexPathArray.append(indexPath)
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell : NotesTableViewCell, indexPath : IndexPath){
        let noteItem = fetchedResultController.object(at: indexPath)
        cell.noteLable.text = noteItem.note
        cell.noteDescriptionLabel.text = noteItem.noteDescription
        if let image = noteItem.photo {
            cell.photo.image = ImageCache.sharedInstance().getImageWithIdentifier(image)
        } else {
            cell.photo.image = UIImage.init(named: "LogoIcon50")
        }
        if noteItem.done {
            cell.doneButton.setImage(UIImage.init(named: "checked"), for: .normal)
        } else {
            cell.doneButton.setImage(UIImage.init(named: "NotCheck"), for: .normal)
        }
        cell.doneButton.tag = indexPathArray.count - 1
        cell.doneButton.addTarget(self, action: #selector(self.setDone(_:)), for: .touchUpInside)
    }
    
    // set done or not
    func setDone(_ sender: UIButton) {
        let indexPath = indexPathArray[sender.tag]
        let item = fetchedResultController.object(at: indexPath)
        item.done = !item.done
        saveContext()
    }
    
    lazy var fetchedResultController : NSFetchedResultsController<Note> = {
        let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest() as NSFetchRequest<Note>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: NoteObject.keys.done, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "goals == %@", self.goalItem!)
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }()
    
    lazy var context : NSManagedObjectContext = {
       return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
