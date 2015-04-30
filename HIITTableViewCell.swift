//
//  HIITTableViewCell.swift
//  FitGen
//
//  Created by David Sanders on 11/30/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

import UIKit

class HIITTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
