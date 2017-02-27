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
    var expiredDate = Date()
    
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
        
        //set datePicker
        datePicker.minimumDate = Date()
        
     //   let todayString = Date().formatDateToString()
        expiredDateButton.setTitle(expiredDate.formatDateToString(), for: .normal)
        
        // delegate UItext
        goalDescriptionText.delegate = self
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
  
    func addKeyboardDismissRecoginze() {
        self.view.addGestureRecognizer(tapGesture!)
    }
    
    func removeKeyboardDismissRecoginze() {
        self.view.removeGestureRecognizer(tapGesture!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapHideKeyboard(){
        self.view.endEditing(true)
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
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    //conform protocol gesture recognizer and set action when start to hold button
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("touch")
        self.saveButton.alpha = 1
        UIView.animate(withDuration: 3, animations: {
            self.saveButton.alpha = 1
        })
        return true
    }
    
    //save or edit data into database
    func saveOrEditData() {
        var item = [String:AnyObject]()
        if goalText.text != "" {
            item[GoalObject.keys.goal] = goalText.text as AnyObject
            item[GoalObject.keys.goalDescription] = goalDescriptionText.text as AnyObject
            item[GoalObject.keys.shortTerm] = shortTem.isOn as AnyObject
            item[GoalObject.keys.expiredDate] = expiredDate as AnyObject
            item[GoalObject.keys.createdDate] = Date() as AnyObject
            item[GoalObject.keys.photo_path] = ImageCache.sharedInstance().setImageRetunPath(image: self.image, date: Date()) as AnyObject
            let _ = GoalObject(goalItem: item, context: context)
            saveContext()
        }
    }
}
