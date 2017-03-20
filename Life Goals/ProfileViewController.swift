//
//  ProfileViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/9/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var pointImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stacKView: UIStackView!
    @IBOutlet weak var notificationOnOffLabel: UILabel!
    @IBOutlet weak var notificationNoteLabel: UILabel!
    
    
    let pref = UserDefaults.standard
    var tapNameGestures : UITapGestureRecognizer? = nil
    let bannerAds = AdsClass("ca-app-pub-5300329803332227/8769289390")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let maxY = navigationController?.navigationBar.frame.maxY
        let bannerView = bannerAds.getBannerView(maxY!,rootViewController : self)
        view.addSubview(bannerView)
    }
    
    func setupLayout() {
        //set mask image
        profileImage.layer.borderWidth = 1
        profileImage.layer.cornerRadius = 75
        profileImage.layer.masksToBounds = true
        
        //set profile Image
        if let imageString = pref.string(forKey: "imageProfile") {
            if imageString != "" {
                profileImage.image = ImageCache.sharedInstance().getImageWithIdentifier(imageString)
            }else{
                profileImage.image = UIImage.init(named: "BigLogo")
            }
        }
        
        //get points and stars form app
        pointLabel.text = pref.string(forKey: "points")
        starLabel.text = pref.string(forKey: "stars")
        nameLabel.text = pref.string(forKey: "name")
        
        //set tap into name label
        tapNameGestures = UITapGestureRecognizer(target: self, action: #selector(self.nameChange(_:)))
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(tapNameGestures!)
        
        //check camera avaiable
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //check notfication authorization
        if let status = pref.value(forKey: "notification") as? Bool {
            if status {
                notificationOnOffLabel.text = "On"
                notificationNoteLabel.isHidden = true
            } else {
                notificationOnOffLabel.text = "off"
                notificationNoteLabel.isHidden = false
            }
        }
    }
    
    func nameChange(_ gesture : UIGestureRecognizer) {
        let alertVC = UIAlertController(title: "Change name", message: "Who are you ?", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: {textField in
            textField.placeholder = "Enter your name"
        })
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler : {  action in
            if action.style == .default {
                if let textField = alertVC.textFields?[0].text {
                    if textField != "" {
                        self.pref.set(textField, forKey: "name")
                        self.nameLabel.text = self.pref.string(forKey: "name")
                    }
                }
                
            }
        })
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setImageFromPicker(pickerType : UIImagePickerControllerSourceType){
        let imageVC = UIImagePickerController()
        imageVC.sourceType = pickerType
        imageVC.allowsEditing = false
        imageVC.delegate = self
        present(imageVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageString = ImageCache.sharedInstance().setImageRetunPath(image: image, date: Date())
        pref.set(imageString, forKey: "imageProfile")
        profileImage.image = image
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraAction(_ sender: Any) {
        setImageFromPicker(pickerType: .camera)
    }
    
    @IBAction func galleryAction(_ sender: Any) {
        setImageFromPicker(pickerType: .photoLibrary)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        pref.set(nil, forKey: "imageProfile")
        profileImage.image = UIImage.init(named: "BigLogo")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
