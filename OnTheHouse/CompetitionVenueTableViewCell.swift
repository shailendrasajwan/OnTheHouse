//
//  CompetitionVenueTableViewCell.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 30/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class CompetitionVenueTableViewCell: UITableViewCell {

    @IBOutlet weak var venueInformationLabel: UILabel!
    @IBOutlet weak var venueName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
