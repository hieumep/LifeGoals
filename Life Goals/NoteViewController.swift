//
//  NoteViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/6/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, GADInterstitialDelegate {
    
    
    @IBOutlet weak var note: UITextField!
    @IBOutlet weak var noteDescription: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!

    var goalItem : Goal?
    var image : UIImage? = nil
    var tapGesture : UITapGestureRecognizer?
    var longPressGesture : UILongPressGestureRecognizer?
    let adUnitID = "ca-app-pub-5300329803332227/1246022596"
    var interstitial: GADInterstitial!
    var noteItem : Note?
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        interstitial = createAndLoadInterstitial()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        //setup border of text field, text view
        note.layer.cornerRadius = 15
        note.layer.borderWidth = 1
        note.layer.borderColor = UIColor.lightGray.cgColor
        noteDescription.layer.cornerRadius = 15
        noteDescription.layer.borderWidth = 1
        noteDescription.layer.borderColor = UIColor.lightGray.cgColor
        noteDescription.delegate = self
        imageView.layer.borderWidth = 1
        
        // check camera avaible
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //set tap to hide keyboard
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHideKeyboard(gesture:)))
        tapGesture?.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture!)
        
        //set longPress for save Button
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.holdLongPress(gesture:)))
        longPressGesture?.minimumPressDuration = 3
        longPressGesture?.delegate = self
        saveButton.addGestureRecognizer(longPressGesture!)
        
        //Load edit item to field
        if let item = noteItem {
            note.text = item.note
            noteDescription.text = item.noteDescription
            imageView.image = ImageCache.sharedInstance().getImageWithIdentifier(item.photo)
            goalItem = noteItem?.goals
            saveButton.setTitle("Hold to Edit", for: .normal)
        }
    }
    
    //set action when hold long press
    func holdLongPress(gesture : UIGestureRecognizer) {
        if gesture.state == .ended {
           // print("done")
            if note.text != "" {
                saveData()
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                }else {
                    _ = navigationController?.popViewController(animated: true)
                }
            }
         //   dismiss(animated: true, completion: nil)
        }
    }
    
    // set delegate for gesture 
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        saveButton.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            self.saveButton.alpha = 1
        })
        return true
    }
    
    //save data to database 
    func saveData(){
        var noteDesc = ""
        if noteDescription.text != "Your note description..." {
            noteDesc = noteDescription.text
        } else {
            noteDesc = ""
        }
        if let noteItem = noteItem {
            noteItem.note = note.text
            noteItem.noteDescription = noteDesc
            if image != nil {
                noteItem.photo = ImageCache.sharedInstance().setImageRetunPath(image: image, date: Date())
            }
        }else {
            var item = [String:AnyObject]()
            item[NoteObject.keys.note] = note.text as AnyObject
            item[NoteObject.keys.noteDescription] = noteDesc as AnyObject
            item[NoteObject.keys.photo_path] = ImageCache.sharedInstance().setImageRetunPath(image: image, date: Date()) as AnyObject
            item[NoteObject.keys.goals] = goalItem
            _ = NoteObject(noteItem: item, context: context)
        }
        saveContext()
    }
    
    //declare context
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
    
    //set to hide keyboard
    func tapHideKeyboard(gesture : UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.view.removeGestureRecognizer(tapGesture!)
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.isEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
  
    @IBAction func galleryAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.isEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagePicked = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleToFill
        imagePicked.withHorizontallyFlippedOrientation()
        imageView.image = imagePicked
        image = imagePicked
        dismiss(animated: true, completion: nil)
    }


    @IBAction func deletePhoto(_ sender: Any) {
        image = nil
        imageView.image = image
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: adUnitID)
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID]
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        _ = dismiss(animated: true, completion: nil)
    }
   
    //set image when image = nil
    // set hold to save

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
