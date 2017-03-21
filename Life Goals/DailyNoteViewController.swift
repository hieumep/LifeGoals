//
//  DailyNoteViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/14/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class DailyNoteViewController: UIViewController{

    @IBOutlet weak var dailyNoteText: CustomTextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var noteItem : DailyNote?
    
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    var tapGesture : UITapGestureRecognizer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        view.addGestureRecognizer(tapGesture!)
        
        if let noteItem = noteItem {
            dailyNoteText.text = noteItem.dailyNote
            saveButton.setTitle("Edit", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    func hideKeyboard(_ gesture : UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.removeGestureRecognizer(tapGesture!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if dailyNoteText.text != "" {
            if let item = noteItem {
                item.dailyNote = dailyNoteText.text
            }else {
                var item = [String : String]()
                item[DailyNoteObject.keys.dailyNote] = dailyNoteText.text
                item[DailyNoteObject.keys.createdDate] = Date().formatShortDateToString()
                _ = DailyNoteObject.init(item: item, context: context)
            }
            saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
       
}
