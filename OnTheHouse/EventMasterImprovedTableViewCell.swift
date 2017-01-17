//
//  EventMasterImprovedTableViewCell.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 9/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class EventMasterImprovedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventPriceHeading: UILabel!
    @IBOutlet weak var priceString: UILabel!
    
    @IBOutlet weak var goldMemberImage: UIImageView!
    
    @IBOutlet weak var bronzeMemberImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
