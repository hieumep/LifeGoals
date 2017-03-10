//
//  ProfileViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/9/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var pointImage: UIImageView!
    
    
    let pref = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.cornerRadius = 75
        profileImage.layer.masksToBounds = true
        pointLabel.text = pref.string(forKey: "points")
        starLabel.text = pref.string(forKey: "stars")
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
