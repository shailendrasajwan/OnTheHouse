//
//  StateTableViewCell.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 23/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
