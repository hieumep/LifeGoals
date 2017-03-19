//
//  GoalViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/20/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

class GoalViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var goalDescriptionText: UITextView!
    @IBOutlet weak var goalText: UITextField!
    @IBOutlet weak var upPhoto: UIImageView!
    @IBOutlet weak var expiredDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shortTem: UISwitch!
    
    var longPress = UILongPressGestureRecognizer()
    var tapGesture : UITapGestureRecognizer? = nil
    var flagDate = true
    var image : UIImage? = nil
    var expiredDate = Date().getTomorrow()
    var goalItem : Goal?
    var shortTerm = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.saveAction(gestureRecoginer:)))
        longPress.minimumPressDuration = 3
        longPress.delegate = self
        saveButton.addGestureRecognizer(longPress)
        setupLayout()
        
        // Do any additional setup after loading the view.
    }
    
    //action when tap camera icon
    @IBAction func cameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //action when tap gallery button
    @IBAction func galleryAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    //setup some layout
    func setupLayout (){
        //set avaible for cameraAction
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        //set layer out for text flied
        goalText.layer.cornerRadius = 15.0
        goalText.layer.borderWidth = 1.0
        goalText.layer.borderColor = UIColor.gray.cgColor
        goalDescriptionText.layer.cornerRadius = 15.0
        goalDescriptionText.layer.borderWidth = 1.0
        goalDescriptionText.layer.borderColor = UIColor.gray.cgColor
        upPhoto.layer.borderWidth = 1.0
        upPhoto.layer.borderColor = UIColor.gray.cgColor
        
        //add Gesture into View
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHideKeyboard))
        tapGesture?.numberOfTapsRequired = 1
        addKeyboardDismissRecoginze()
        
        //set short term or long term 
        shortTem.isOn = shortTerm
        
        //set datePicker
        datePicker.minimumDate = expiredDate
        
     //   let todayString = Date().formatDateToString()
        expiredDateButton.setTitle(expiredDate.formatDateToString(), for: .normal)
        
        // delegate UItext
        goalDescriptionText.delegate = self
        
        //add tap gesture recoginizer into imageView
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(self.tapImage(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureImage)
        
        //if there has item to edit
        if let goalItem = goalItem {
            goalText.text = goalItem.goal
            goalDescriptionText.text = goalItem.goalDescription
            shortTem.isOn = goalItem.shortTerm
            expiredDate = goalItem.expiredDate as! Date
            expiredDateButton.setTitle(expiredDate.formatDateToString(), for: .normal)
            datePicker.date = expiredDate
            image = ImageCache.sharedInstance().getImageWithIdentifier(goalItem.photo)
            imageView.image = image
            if goalItem.done {
                saveButton.setTitle("This Goal is done or expired", for: .normal)
                saveButton.isEnabled = false
            } else {
                saveButton.setTitle("Hold to edit", for: .normal)
            }
        }
        
        
    }
    
    func tapImage(_ gestureRecognizer : UIGestureRecognizer) {
        if let image = self.image {
            let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoViewController") as! PhotoViewController
            photoVC.image = image
            self.present(photoVC, animated: true, completion: nil)
        }
    }
    
    // when pick date
    @IBAction func pickDate(_ sender: Any) {
        expiredDate = datePicker.date
        expiredDateButton.setTitle(expiredDate.formatDateToString(), for: .normal)
    }
   
    @IBAction func pickExpiredDate(_ sender: Any) {
        flagDate = !flagDate
        datePicker.isHidden = flagDate
    }
  
    @IBAction func deleteImage(_ sender: Any) {
        image = nil
        imageView.image = image
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardDismissRecoginze()
    }
    
    // Set delegate Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleToFill
        pickedImage.withHorizontallyFlippedOrientation()
        imageView.image = pickedImage
        self.image = pickedImage
        dismiss(animated: true, completion: nil)
   }

    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
    
    //call when after hold save button
    func saveAction(gestureRecoginer : UIGestureRecognizer) {
        if gestureRecoginer.state == UIGestureRecognizerState.ended {
           // saveButton.setTitle("Saved", for: .normal)
           // saveButton.isEnabled = false
            saveOrEditData()
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    //conform protocol gesture recognizer and set action when start to hold button
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      //  print("touch")
        saveButton.alpha = 1
        UIView.animate(withDuration: 3, animations: {
            self.saveButton.alpha = 1
        })
        return true
    }
    
    //save or edit data into database
    func saveOrEditData() {
        if let goalItem = goalItem {
            goalItem.goal = goalText.text
            goalItem.goalDescription = goalDescriptionText.text
            goalItem.shortTerm = shortTem.isOn
            goalItem.expiredDate = expiredDate as NSDate
            goalItem.photo = ImageCache.sharedInstance().setImageRetunPath(image: self.image, date: Date())
        } else {
            var item = [String:AnyObject]()
            if goalText.text != "" {
                item[GoalObject.keys.goal] = goalText.text as AnyObject
                item[GoalObject.keys.goalDescription] = goalDescriptionText.text as AnyObject
                item[GoalObject.keys.shortTerm] = shortTem.isOn as AnyObject
                item[GoalObject.keys.expiredDate] = expiredDate as AnyObject
                item[GoalObject.keys.createdDate] = Date() as AnyObject
                item[GoalObject.keys.photo_path] = ImageCache.sharedInstance().setImageRetunPath(image: self.image, date: Date()) as AnyObject
                let _ = GoalObject(goalItem: item, context: context)
            }else {
                let alertVC = UIAlertController(title: "Alert", message: "Goal can't not empty", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
                alertVC.addAction(alertAction)
                present(alertVC, animated: true, completion: nil)
            }
        }
        saveContext()    
    }
}
