//
//  TutorialVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

    var page = 1 {
        didSet {
            setImg()
        }
    }
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var tutorialImgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setLogoInNaviBar()
    }
    
    private func setImg() {
        self.tutorialImgV.image = UIImage(named: "tutorial\(page)Image")
    }
    
    private func setView() {
        self.skipBtn.applyRadius(radius: 10)
    }
    

    @IBAction func clickedBack(_ sender: UIButton) {
        if page > 1 {
            page = page - 1
        }
    }
    
    @IBAction func clickedNext(_ sender: UIButton) {
        if page < 3 {
            page = page + 1
        }
    }
    @IBAction func clickedSkip(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainChooseVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
