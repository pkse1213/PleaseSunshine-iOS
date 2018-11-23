//
//  SimulationVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class SimulationVC: UIViewController {

    
    @IBOutlet weak var lookBtn: UIButton!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        yearLbl.adjustsFontSizeToFitWidth = true
        priceLbl.adjustsFontSizeToFitWidth = true
        infoLbl.adjustsFontSizeToFitWidth = true
        setLogoInNaviBar()
        print("simulateor")
    }
    

}
