//
//  GoalViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/20/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController {

    @IBOutlet weak var goalDescriptionText: UITextView!
    @IBOutlet weak var goalText: UITextField!
    @IBOutlet weak var upPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalText.layer.cornerRadius = 15.0
        goalText.layer.borderWidth = 1.0
        goalText.layer.borderColor = UIColor.gray.cgColor
        goalDescriptionText.layer.cornerRadius = 15.0
        goalDescriptionText.layer.borderWidth = 1.0
        goalDescriptionText.layer.borderColor = UIColor.gray.cgColor
        upPhoto.layer.borderWidth = 1.0
        upPhoto.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
