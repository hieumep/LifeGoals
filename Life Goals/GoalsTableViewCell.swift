//
//  GoalsTableViewCell.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/28/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class GoalsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var progessLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var doneLabel: UIButton!
    @IBOutlet weak var progessView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
