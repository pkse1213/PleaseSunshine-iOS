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
    var lookCost: [LookCost]? //{
//        didSet{
//            setCostLookData()
//        }
//    }
    var choosenPlace: MyPlace? {
        didSet {
            energyDataInit()
        }
    }
    
    let userdefault = UserDefaults.standard
    var unit:CGFloat = 0.0
    var longitude = 0.0
    var latitude = 0.0
    let numberFormatter = NumberFormatter()
    
    // 카테고리 탭 outlet
    @IBOutlet weak var addressChangeBtn: UIBarButtonItem!
    @IBOutlet var tabBtns: [UIButton]!
    @IBOutlet var tabUnderVars: [UIView]!
    @IBOutlet var parentVs: [UIView]!
    
    // 에너지 outlet
    let energyMessages = ["매우 효율적입니다:)", "효율적입니다:)","보통입니다:]","비효율적이에요:("]
    let energyColors = [ #colorLiteral(red: 0.0862745098, green: 0.6980392157, blue: 0.4941176471, alpha: 1), #colorLiteral(red: 0.0862745098, green: 0.6980392157, blue: 0.4941176471, alpha: 1), #colorLiteral(red: 1, green: 0.7647058824, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)]
    let energyBgImgs = [#imageLiteral(resourceName: "energyVeryGoodImage"),#imageLiteral(resourceName: "energyGoodImage"),#imageLiteral(resourceName: "energyNormalImage"),#imageLiteral(resourceName: "energyBadImage")]
    @IBOutlet weak var energyBgImgV: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var simulationBtn: UIButton!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var kWhLbl: UILabel!
    
    // 비용 outlet
    let categories = ["설치비용", "손익분기", "생산전력", "절감효과"]
    let texts = ["실부담금이 예상됩니다.","설치비용을 회수할 수 있습니다.","냉장고를 가동할 수 있습니다.","마실 수 있습니다." ]
    let detailTexts = ["[250W 최저설치비용 기준]","","[에너지효율 1등급/840L 기준]","[스타벅스 아메리카노 Tall 기준]" ]
    let images = [#imageLiteral(resourceName: "costSetting"), #imageLiteral(resourceName: "costClock"), #imageLiteral(resourceName: "costRefrigerator"), #imageLiteral(resourceName: "costCoffee")]
    let watts = [250,260,270,300]
    @IBOutlet weak var costCV: UICollectionView!
    @IBOutlet weak var lookBtn: UIButton!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var yearCostLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    // 비용-한눈에 알아보기 outlet
    @IBOutlet weak var lookParentV: UIView!
    @IBOutlet weak var lookV: UIView!
    
    @IBOutlet var saveMoneyLbls: [UILabel]!
    @IBOutlet var installCostLbls: [UILabel]!
    @IBOutlet var bePointLbls: [UILabel]!
   
    // 환경 outlet
    let outputCategories = ["이산화탄소 배출량" ,"질소산화물 배출량", "초미세먼지 배출량"]
    @IBOutlet weak var environmentTbV: UITableView!
    @IBOutlet weak var busanSoxBtn: UIButton!
    var busansox = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .decimal
        initServiceData()
        setLogoInNaviBar()
        setView()
        checkSetAddress()
        setTarget()
        setBusansox()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(addressGetter), name: NSNotification.Name("setAddress") , object: nil)
    }
    
    func setBusansox() {
        EnvironmentService.shareInstance.getEnvironmentInfo(completion: { (busansox) in
            self.busansox = busansox
            print("busansox 성공")
        }) { (err) in
            print("busansox 실패")
        }
    }
    
    @IBAction func simulator(_ sender: Any) {
//        simpleAlertWithCompletionOnlyOk(title: "알림", message: "기능 준비 중 입니다.", okCompletion: nil)
//        ARSimulatorVC
        let vc = UIStoryboard(name: "ARSimulator", bundle: nil).instantiateViewController(withIdentifier: "ARSimulatorVC") as! ARSimulatorVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func setTarget() {
        busanSoxBtn.layer.cornerRadius = 25/2
        busanSoxBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ]
        busanSoxBtn.addTarget(self, action: #selector(self.pressedBusanSoxBtn(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func pressedBusanSoxBtn( _ sender : UIButton ) {
        guard let airPollutantsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AirPollutantsViewController") as? AirPollutantsViewController else { return }
        
        airPollutantsVC.busansox = self.busansox
        self.addChild( airPollutantsVC )
        airPollutantsVC.view.frame = self.view.frame
        self.view.addSubview( airPollutantsVC.view )
        airPollutantsVC.didMove(toParent: self )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSetAddress()
    }
    
    @IBAction func changeAddress(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "LocationMapVC") as! LocationMapVC
        self.present(vc, animated: true, completion: nil)
    }
    
    private func checkSetAddress() {
        guard let lat = userdefault.double(forKey: "latitude") as? Double, let lon = userdefault.double(forKey: "longitude") as? Double, let name = userdefault.string(forKey: "name"), let angle = userdefault.integer(forKey: "angle") as? Int else {
            let vc = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "LocationMapVC") as! LocationMapVC
            self.present(vc, animated: true, completion: nil)
            return
        }
        let place = MyPlace(name: name , lat:lat, lon: lon, angle: angle)
        choosenPlace = place
    }
    
    @objc func addressGetter(notification:Notification) {
        if let p = notification.object as? MyPlace{
            let place = MyPlace(name: p.name , lat:p.lat, lon: p.lon, angle: p.angle)
            choosenPlace = place
            print("change")
            print(place)
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
       
        // 비용-한눈에 알아보기
        lookV.applyRadius(radius: 10)
        lookParentV.isHidden = true
        
        // 환경
        environmentTbV.delegate = self
        environmentTbV.dataSource = self
        parentVs[2].isHidden = true
    }
    
    private func setEnergyData() {
        print("에너지 퍼센트 변경")
        guard let energy = self.energy else {return}
        self.percentLbl.text = "\(energy.persent)"
        self.kWhLbl.text = "\(energy.sunshine)"
        
        if energy.persent > 75 {
            self.messageLbl.text = energyMessages[0]
            self.energyBgImgV.image = energyBgImgs[0]
            self.percentLbl.textColor = energyColors[0]
        } else if energy.persent > 50 {
            self.messageLbl.text = energyMessages[1]
            self.energyBgImgV.image = energyBgImgs[1]
            self.percentLbl.textColor = energyColors[1]
        } else if energy.persent > 25 {
            self.messageLbl.text = energyMessages[2]
            self.energyBgImgV.image = energyBgImgs[2]
            self.percentLbl.textColor = energyColors[2]
        } else {
            self.messageLbl.text = energyMessages[3]
            self.energyBgImgV.image = energyBgImgs[3]
            self.percentLbl.textColor = energyColors[3]
        }
    }
    
    private func setCostData() {
        guard let cost = self.cost else {return}
        let result = numberFormatter.string(from: NSNumber(value:cost.savedMoney*12))!
        self.yearCostLbl.text = "\(result)원"
    }
    
    private func setCostLookData(){
        guard let cost = self.lookCost else {return}
        for i in 0...3{
            let result1 = numberFormatter.string(from: NSNumber(value:cost[i].savedMoney))!
            let result2 = numberFormatter.string(from: NSNumber(value:cost[i].installCostAvg))!
            
            saveMoneyLbls[i].text = "\(result1)원"
            installCostLbls[i].text = "\(result2)원"
            bePointLbls[i].text = "\(cost[i].bePoint)개월"
        }
    }
    
    private func energyDataInit() {
        guard let place = choosenPlace else {
            return
        }
        EnergyService.shareInstance.getEnergyInfo(lat: place.lat, lon: place.lon, angle: Double(place.angle), completion: { (Energy) in
            self.energy = Energy
            print("energy init 성공")
            print(place)
            
        }) { (err) in
            print("energy init 실패")
        }
    }
    
    private func initServiceData(){
        CostService.shareInstance.getCostInfo(watt: 250, completion: { (Cost) in
            self.cost = Cost[0]
        }) { (err) in
            print("cost init 실패")
        }
        LookCostService.shareInstance.getCostLookInfo(completion: { (LookCost) in
            self.lookCost = LookCost
        }) { (err) in
             print("look init 실패")
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
            self.cost = Cost[0]
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
        cell.detailLabel.text = detailTexts[indexPath.item]
        cell.commentLbl.text = texts[indexPath.row]
        guard let cost = self.cost else {return cell}
        if indexPath.item == 0 {
            let result = numberFormatter.string(from: NSNumber(value:cost.installCostAvg))!
            cell.dataLbl.text = "\(result)원"
        } else if indexPath.item == 1 {
            cell.dataLbl.text = "\(cost.bePoint)개월"
        } else if indexPath.item == 2 {
            cell.dataLbl.text = "\(cost.volunteer)일"
        } else {
            cell.dataLbl.text = "\(cost.coffee)잔의 커피"
        }
        return cell
    }
}

extension SimulationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = environmentTbV.dequeueReusableCell(withIdentifier: "EnvironmentCell") as! EnvironmentCell
        cell.imageview.image = UIImage(named: "environmentImage\(indexPath.row+1)")
        
        return cell
    }
}
