//
//  MasterDetailTableViewCell.swift
//  OnTheHouse
//
//  Created by Danielle Hendricks on 26/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class MasterDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var FullPrice: UILabel!
    @IBOutlet weak var EventHeadingPrice: UILabel!
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var GoldImage: UIImageView!
    @IBOutlet weak var BronzeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
