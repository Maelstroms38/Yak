//
//  StandTableViewCell.swift
//  Yak
//
//  Created by Michael Stromer on 1/15/15.
//  Copyright (c) 2015 Michael Stromer. All rights reserved.
//

import UIKit

class StrandTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var strandLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
