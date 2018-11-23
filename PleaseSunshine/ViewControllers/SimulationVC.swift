//
//  SimulationVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class SimulationVC: UIViewController {
    let userdefault = UserDefaults.standard
    
    var longitude = 0.0
    var latitude = 0.0
    // 카테고리 탭 outlet
    @IBOutlet var tabBtns: [UIButton]!
    @IBOutlet var tabUnderVars: [UIView]!
    @IBOutlet var parentVs: [UIView]!
    
    // 에너지 outlet
    @IBOutlet weak var simulationBtn: UIButton!
    
    // 비용 outlet
    @IBOutlet weak var lookBtn: UIButton!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var costSquareV1: UIView!
    @IBOutlet weak var costSquareV2: UIView!
    @IBOutlet weak var costSquareV3: UIView!
    @IBOutlet weak var costSquareV4: UIView!
    
    // 비용-한눈에 알아보기 outlet
    @IBOutlet weak var lookParentV: UIView!
    @IBOutlet weak var lookV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoInNaviBar()
        setView()
        checkSetAddress()
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(addressGetter), name: NSNotification.Name("setAddress") , object: nil)
    }
    
    private func checkSetAddress() {
        guard let lat = userdefault.string(forKey: "latitude"), let long = userdefault.string(forKey: "longitude") else {
            let vc = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as! MapVC
            self.present(vc, animated: true, completion: nil)
            return
        }
        self.latitude = Double(lat)!
        self.longitude = Double(long)!
        print(self.latitude)
        print(self.longitude)
        
    }
    
    
    @objc func addressGetter(notification:Notification) {
        if let address = notification.object as? [Double]{
            self.latitude = address[0]
            self.longitude = address[1]
        }
    }

    
    private func setView() {
        // 카테고리 탭
        tabUnderVars[1].isHidden = true
        tabUnderVars[2].isHidden = true
        
        // 에너지
        simulationBtn.applyRadius(radius: 10)
        // 비용
        yearLbl.font = yearLbl.font.withSize(adjustFontSize(size: 13))
        costLbl.font = costLbl.font.withSize(adjustFontSize(size: 27))
        infoLbl.font = infoLbl.font.withSize(adjustFontSize(size: 13))
        parentVs[1].isHidden = true
        lookBtn.applyRadius(radius: lookBtn.frame.size.height/2)
        costSquareV1.applyRadius(radius: 10)
        costSquareV2.applyRadius(radius: 10)
        costSquareV3.applyRadius(radius: 10)
        costSquareV4.applyRadius(radius: 10)
        
        // 비용-한눈에 알아보기
        lookV.applyRadius(radius: 10)
        lookParentV.isHidden = true
        // 환경
        parentVs[2].isHidden = true
        
    }
    
    private func adjustFontSize(size: CGFloat) -> CGFloat{
        let sizeFormatter = size/375
        let result = self.view.frame.size.width*sizeFormatter
        return result
    }
    
    // 비용
    @IBAction func selectCategoryTab(_ sender: UIButton) {
        for i in 0...2 {
            if i == sender.tag {
                tabBtns[i].setTitleColor(#colorLiteral(red: 1, green: 0.6965169907, blue: 0, alpha: 1), for: .normal)
                tabUnderVars[i].isHidden = false
                parentVs[i].isHidden = false
            } else {
                tabBtns[i].setTitleColor(#colorLiteral(red: 0.7685508132, green: 0.768681109, blue: 0.7685337067, alpha: 1), for: .normal)
                tabUnderVars[i].isHidden = true
                parentVs[i].isHidden = true
            }
        }
    }
    @IBAction func popLookView(_ sender: UIButton) {
        lookParentV.isHidden = false
    }
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        
    }
    
    // 비용-한눈에 알아보기
    @IBAction func closeLookView(_ sender: UIButton) {
        lookParentV.isHidden = true
    }
    

}
