//
//  MainChooseVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class MainChooseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoInNaviBar()
        self.navigationItem.hidesBackButton = true
    }
    @IBAction func clickedGo(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarCV") as! UITabBarController
        vc.selectedIndex = sender.tag
        self.present(vc, animated: false)
        
    }
    

}
