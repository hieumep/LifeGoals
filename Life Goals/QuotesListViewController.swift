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
        let fetchedResultsContoller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sessionInfo = fetchedResultsContoller.sections![section]
        return sessionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = fetchedResultsContoller.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesListCell") as! QuotesListTableViewCell
        cell.quoteLabel.text = item.quote
        cell.authorLabel.text = item.author
        return cell
    }
    

    // try do section with tabel View

}
