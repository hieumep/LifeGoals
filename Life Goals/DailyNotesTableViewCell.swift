//
//  DailyNotesTableViewCell.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/14/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

class DailyNotesTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
