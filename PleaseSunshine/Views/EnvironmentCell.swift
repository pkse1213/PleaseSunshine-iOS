//
//  EnvironmentCell.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 25..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class EnvironmentCell: UITableViewCell {
//let cado, nox, udst: OutputAmount
//    sun, kospo, thermalPower
    @IBOutlet weak var thermalPowerImgV: UIImageView!
    @IBOutlet weak var kospoImgV: UIImageView!
    @IBOutlet weak var sunImgV: UIImageView!
    
    @IBOutlet weak var thermalHeight: NSLayoutConstraint!
    @IBOutlet weak var kospoHeight: NSLayoutConstraint!
    @IBOutlet weak var sunHeight: UIImageView!
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var backgroundImgV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImgV.applyRadius(radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
