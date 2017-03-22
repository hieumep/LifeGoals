//
//  QuotesListViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/13/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class QuotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()

    lazy var fetchedResultsContoller : NSFetchedResultsController<Quote> = {
        let fetchRequest : NSFetchRequest<Quote> = Quote.fetchRequest() as NSFetchRequest<Quote>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: QuoteObject.keys.author, ascending: true)]
        let fetchedResultsContoller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: #keyPath(Quote.author), cacheName: nil)
        fetchedResultsContoller.delegate = self
        return fetchedResultsContoller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsContoller.performFetch()
        } catch{
            print(error)
        }
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsContoller.sections else {return 0}
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sessionInfo = fetchedResultsContoller.sections![section]
        return sessionInfo.name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = fetchedResultsContoller.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesListCell") as! QuotesListTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell : QuotesListTableViewCell, indexPath : IndexPath) {
        let item = fetchedResultsContoller.object(at: indexPath)
        cell.quoteLabel.text = item.quote
        cell.authorLabel.text = item.author
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quoteVC = storyboard?.instantiateViewController(withIdentifier: "quoteViewController") as! QuoteViewController
        let item = fetchedResultsContoller.object(at: indexPath)
        quoteVC.quoteItem = item
        navigationController?.pushViewController(quoteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            let item = fetchedResultsContoller.object(at: indexPath)
            context.delete(item)
            break
        default:
            break
        }
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
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete :
            if let indexPath = indexPath {
                if tableView.numberOfRows(inSection: indexPath.section) == 1{
                    tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }else{
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            break
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? QuotesListTableViewCell {
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
            
        case .move :
            if let indexPath = indexPath {
                if tableView.numberOfRows(inSection: indexPath.section) == 1{
                    tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                }else{
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }

            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break
        }
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

    // try do section with tabel View

}
