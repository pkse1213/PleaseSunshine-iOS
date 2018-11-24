//
//  SimulationVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class SimulationVC: UIViewController {
    var energy: Energy? {
        didSet{
            setEnergyData()
        }
    }
    var cost: Cost? {
        didSet{
            setCostData()
            costCV.reloadData()
        }
    }
    var environment: OutputClass?{
        didSet{
            setEnvironmentData()
        }
    }
    
    let userdefault = UserDefaults.standard
    var unit:CGFloat = 0.0
    var longitude = 0.0
    var latitude = 0.0
    
    // 카테고리 탭 outlet
    @IBOutlet var tabBtns: [UIButton]!
    @IBOutlet var tabUnderVars: [UIView]!
    @IBOutlet var parentVs: [UIView]!
    
    // 에너지 outlet
    @IBOutlet weak var simulationBtn: UIButton!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var kWhLbl: UILabel!
    
    // 비용 outlet
    let categories = ["설치비용", "손익분기점", "봉사", "커피"]
    let images = [#imageLiteral(resourceName: "costSetting"), #imageLiteral(resourceName: "costClock"), #imageLiteral(resourceName: "costBaby"), #imageLiteral(resourceName: "costCoffee")]
    let energyImages = [#imageLiteral(resourceName: "energyVeryGoodImage"), #imageLiteral(resourceName: "energyGoodImage"), #imageLiteral(resourceName: "energyNormalImage"), #imageLiteral(resourceName: "energyBadImage")]
    let watts = [250,260,270,300]
    @IBOutlet weak var costCV: UICollectionView!
    @IBOutlet weak var lookBtn: UIButton!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var yearCostLbl: UILabel!
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
        initServiceData()
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
        unit = self.view.frame.width
        // 카테고리 탭
        tabUnderVars[1].isHidden = true
        tabUnderVars[2].isHidden = true
        
        // 에너지
        simulationBtn.applyRadius(radius: 10)
        
        // 비용
        costCV.delegate = self
        costCV.dataSource = self
        yearLbl.font = yearLbl.font.withSize(adjustFontSize(size: 13))
        yearCostLbl.font = yearCostLbl.font.withSize(adjustFontSize(size: 27))
        infoLbl.font = infoLbl.font.withSize(adjustFontSize(size: 13))
        parentVs[1].isHidden = true
        lookBtn.applyRadius(radius: 13.5*self.view.frame.width/375)
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
    private func setEnergyData() {
        guard let energy = self.energy else {return}
        self.percentLbl.text = "\(energy.persent)"
        self.kWhLbl.text = "\(energy.sunshine)"
    }
    
    private func setCostData() {
        guard let cost = self.cost else {return}
        self.yearCostLbl.text = "\(cost.savedMoney)원"
    }
    
    private func setEnvironmentData() {
//        guard let environment = self.environment else {return}
        
    }
    
    private func initServiceData(){
        EnergyService.shareInstance.getEnergyInfo(lat: self.latitude, lon: self.longitude, angle: 30, completion: { (Energy) in
            self.energy = Energy
        }) { (err) in
            print("energy init 실패")
        }
        CostService.shareInstance.getCostInfo(watt: 250, completion: { (Cost) in
            self.cost = Cost
        }) { (err) in
            print("cost init 실패")
        }
        EnvironmentService.shareInstance.getEnvironmentInfo(completion: { (OutputClass) in
            self.environment = OutputClass
        }) { (err) in
            print("environment init 실패")
        }
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
        CostService.shareInstance.getCostInfo(watt: watts[sender.selectedSegmentIndex], completion: { (Cost) in
            self.cost = Cost
        }) { (err) in
            print("cost init 실패")
        }
    }
    
    // 비용-한눈에 알아보기
    @IBAction func closeLookView(_ sender: UIButton) {
        lookParentV.isHidden = true
    }
}

extension SimulationVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = costCV.dequeueReusableCell(withReuseIdentifier: "CostCell", for: indexPath) as! CostCell
        cell.categoryLbl.text = categories[indexPath.item]
        cell.imgV.image = images[indexPath.item]
        guard let cost = self.cost else {return cell}
        if indexPath.item == 0 {
            cell.dataLbl.text = "\(cost.installCostAvg)원"
        } else if indexPath.item == 1 {
            cell.dataLbl.text = "\(cost.bePoint)개월"
        } else if indexPath.item == 2 {
            cell.dataLbl.text = "\(cost.volunteer)명의 아이들"
        } else {
            cell.dataLbl.text = "\(cost.coffee)잔의 커피"
        }
        return cell
    }
}
