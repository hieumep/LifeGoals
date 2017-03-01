//
//  DoneViewController.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/28/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {
    
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet var starButtons : [UIButton]!
    @IBOutlet weak var experienceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    
    func setupLayout() {
        experienceTextView.layer.cornerRadius = 15
        experienceTextView.layer.borderWidth = 1
        experienceTextView.layer.borderColor = UIColor.gray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rating(_ sender: UIButton) {
        let numberOfStars = sender.tag
        for index in 0 ... 4 {
            if index <= numberOfStars {
                starButtons[index].setImage(UIImage.init(named: "ColorStar"), for: .normal)
            } else {
                starButtons[index].setImage(UIImage.init(named: "noColorStar"), for: .normal)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
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
