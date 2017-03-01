//
//  DoneViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/28/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class DoneViewController: UIViewController {
    
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet var starButtons : [UIButton]!
    @IBOutlet weak var experienceTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var goalItem : Goal?
    var tapGesture : UITapGestureRecognizer?
    var numberOfStars = 0
    var pointDictonary : [Int:Int16] = [0:0,1:3,2:4,3:5,4:6,5:7]
    
    lazy var context : NSManagedObjectContext = {
       return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        //set text View layout and delegate
        experienceTextView.layer.cornerRadius = 15
        experienceTextView.layer.borderWidth = 1
        experienceTextView.layer.borderColor = UIColor.gray.cgColor
        experienceTextView.delegate = self
        
        //get and set goal item
        if let item = goalItem {
            goalLabel.text = item.goal
            photo.image = ImageCache.sharedInstance().getImageWithIdentifier(item.photo)
            print(item.stars)
            rating(star: Int(item.stars))
            if item.points > 0 {
                pointsLabel.text = "Points : \(item.points)"
            }
        }
        
        //set tap to hide keyboards
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHideKeyboard))
        tapGesture?.numberOfTapsRequired = 1
        addKeyboardDismissRecoginze()
        
        //set long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressToSave(gestureRecognizer:)))
        longPress.minimumPressDuration = 3
        longPress.delegate = self
        doneButton.addGestureRecognizer(longPress)
    }
    
    func saveContext() {
        CoreDataStackManager.SharedInstance().saveContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rating(_ sender: UIButton) {
        let Stars = sender.tag
        rating(star: Stars)
    }
    
    func rating(star : Int) {
        for index in 0 ... 4 {
            if index <= star {
                starButtons[index].setImage(UIImage.init(named: "ColorStar"), for: .normal)
            } else {
                starButtons[index].setImage(UIImage.init(named: "noColorStar"), for: .normal)
            }
        }
        numberOfStars = star
    }
    
    @IBAction func cancel(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func saveData() {
        goalItem?.doneDate = Date() as NSDate?
        goalItem?.experience = experienceTextView.text
        goalItem?.stars = Int16(numberOfStars)
        print(numberOfStars)
        goalItem?.points = pointDictonary[numberOfStars+1]!
        saveContext()
    }

    // *** save and set done
    // *** only edit experience if set done
    // use enumation for set point
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
