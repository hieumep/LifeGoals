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
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    let fetchRequest : NSFetchRequest<DailyNote> = DailyNote.fetchRequest()
    let bannerAds = AdsClass("ca-app-pub-5300329803332227/3368557399")
    var indexPathArray = [IndexPath]()
    
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultsController : NSFetchedResultsController<DailyNote> = {
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: DailyNoteObject.keys.createdDate, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: #keyPath(DailyNote.createdDate), cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexPathArray.removeAll()
        loadData(segmentedControl.selectedSegmentIndex)
        let quoteItem = ConvenientClass.shareInstance().getRandomQuote()
        quoteLabel.text = quoteItem.quote
        authorLabel.text = "__" + quoteItem.author + "__"
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let maxY = navigationController?.navigationBar.frame.maxY
        let bannerView = bannerAds.getBannerView(maxY!,rootViewController : self)
        view.addSubview(bannerView)
    }
    
    @IBAction func segmeted(_ sender: UISegmentedControl) {
        indexPathArray.removeAll()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let section = fetchedResultsController.sections else { return 0}
        return section.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections else { return nil}
        return sectionInfo[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections else { return 0}
        return sectionInfo[section].numberOfObjects
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
        indexPathArray.append(indexPath)
        cell.doneButton.tag = indexPathArray.count - 1
        cell.doneButton.addTarget(self, action: #selector(self.checkDone(_:)), for: .touchUpInside)
    }
    
    func checkDone(_ sender : UIButton) {
        let indexPath = indexPathArray[sender.tag]
        let item = fetchedResultsController.object(at: indexPath as IndexPath)
        item.done = !item.done
        saveContext()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)            
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert :
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete :
                tableView.deleteSections(IndexSet(integer : sectionIndex), with: .fade)            
            default:
                break
        }
       
    }
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                }
                break
            case .delete :
                if let indexPath = indexPath {
                    print("section : \(indexPath.section) and rows : \(indexPath.row)")
                    if tableView.numberOfRows(inSection: indexPath.section) < 2 {
                        tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                    }else{
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                   indexPathArray.removeAll()
                    tableView.reloadData()
                }
                break
            case .update:
                if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DailyNotesTableViewCell {
                    configureCell(cell: cell, indexPath: indexPath)
                }
                tableView.reloadData()
                break
                
            case .move :
                if let indexPath = indexPath {
                    if tableView.numberOfRows(inSection: indexPath.section) < 2 {
                        tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                    }else{
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }

                }
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
                tableView.reloadData()
                break            
        }
    }

    func saveContext() {
        CoreDataStackManager.SharedInstance().saveContext()
    }

}
