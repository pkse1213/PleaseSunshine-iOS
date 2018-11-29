//
//  CostCell.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 25..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class CostCell: UICollectionViewCell {
    @IBOutlet weak var backgroundV: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundV.applyRadius(radius: 10)
    }
}
