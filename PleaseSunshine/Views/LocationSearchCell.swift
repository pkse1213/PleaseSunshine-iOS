//
//  LocationSearchCell.swift
//  Woong-iOS
//
//  Created by Leeseungsoo on 2018. 7. 4..
//  Copyright © 2018년 Leess. All rights reserved.
//

import UIKit

class LocationSearchCell: UITableViewCell {
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var roadAddressLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
