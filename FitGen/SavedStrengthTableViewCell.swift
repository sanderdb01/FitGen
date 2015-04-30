//
//  SavedStrengthTableViewCell.swift
//  FitGen
//
//  Created by David Sanders on 1/26/15.
//  Copyright (c) 2015 Bitfountain.io. All rights reserved.
//

import UIKit

class SavedStrengthTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var detailsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
