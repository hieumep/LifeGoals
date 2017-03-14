//
//  QuoteViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/13/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class QuoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var authorText: CustomTextField!
    @IBOutlet weak var quoteText: CustomTextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var quoteItem : Quote?
    var tapGesture : UITapGestureRecognizer? = nil
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHideKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture!)
        
        quoteText.delegate = self
        
        if let quoteItem = quoteItem {
            quoteText.text = quoteItem.quote
            authorText.text = quoteItem.author
            saveButton.setTitle("Edit", for: .normal)
        }
    }
    
    func tapHideKeyboard(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if quoteText.text != "Your quote is ..." && authorText.text != "" {
            if let quoteItem = quoteItem {
                quoteItem.author = authorText.text
                quoteItem.quote = quoteText.text
            } else {
                var quoteItem = [String:AnyObject]()
                quoteItem[QuoteObject.keys.quote] = quoteText.text as AnyObject?
                quoteItem[QuoteObject.keys.author] = authorText.text as AnyObject?
                _ = QuoteObject(quoteItem: quoteItem, context: context)
            }
        }
        saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.removeGestureRecognizer(tapGesture!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text  == "Your quote is ..."  {
            textView.text  = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Your quote is ..."
        }
    }
    
    func saveContext() {
        CoreDataStackManager.SharedInstance().saveContext()
    }

}
