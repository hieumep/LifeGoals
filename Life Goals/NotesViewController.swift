//
//  NotesViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/6/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    
    var goalItem : Goal?
    var expiredDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        //fetch data
        do{
            try fetchedResultController.performFetch()
        } catch{
            print (error)
        }
        // Do any additional setup after loading the view.
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
    }
    
    lazy var fetchedResultController : NSFetchedResultsController<Note> = {
        let fetchRequest : NSFetchRequest<Note> = Note.fetchRequest() as NSFetchRequest<Note>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: NoteObject.keys.done, ascending: true)]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    lazy var context : NSManagedObjectContext = {
       return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
