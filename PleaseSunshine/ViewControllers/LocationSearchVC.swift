//
//  LocationSearchVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 24..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit

class LocationSearchVC: UIViewController {
    
    let cellId = "LocationSearchCell"
    var searchAddress: [Address] = []
    
    @IBOutlet var searchBarView: UIView!
    @IBOutlet var searchBarTxtFd: UITextField!
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchResultTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavi()
    }
    
    private func setupNavi() {
        self.title = "주소 검색"
//        let imv: UIImageView = UIImageView(image: #imageLiteral(resourceName: "imgLogo"))
//
//        navigationItem.titleView = imv
    }
    
    private func setupView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBarView.applyRadius(radius: 17.5)
        searchTableView.tableFooterView = UIView(frame: .zero)
        searchTableView.separatorStyle = .none
        searchBarTxtFd.addTarget(self, action: #selector(search(_:)), for: .editingChanged)
        searchBarTxtFd.addTarget(self, action: #selector(changeResultTitle(_:)), for: .editingChanged)
    }
    
    @objc func search(_ sender: UITextField) {
        if let searchText = sender.text {
            
            KakaoAddressService.shareInstance.searchAddressWithKeyword(query: searchText, completion: { data in
                self.searchAddress = data
                self.searchTableView.reloadData()
            }) { (errCode) in
                self.simpleAlert(title: "네트워크 오류", message: "서버가 응답하지 않습니다.")
            }
        }
    }
    
    @objc func changeResultTitle(_ sender: UITextField) {
        if gbno(sender.text?.isEmpty) {
            searchResultTitle.textColor = UIColor.rgb(red: 112, green: 112, blue: 112)
            searchResultTitle.text = "주소 검색 결과"
        } else {
            searchResultTitle.textColor = #colorLiteral(red: 1, green: 0.4916750789, blue: 0, alpha: 1)
            searchResultTitle.text = "주소 검색 결과 \"" + gsno(sender.text) + "\""
        }
    }
    
}

extension LocationSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAddress.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LocationSearchCell
        
        cell.addressLabel.text = searchAddress[indexPath.row].placeName
        cell.roadAddressLabel.text = searchAddress[indexPath.row].roadAddressName
        cell.deleteButton.isHidden = true
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let address = searchAddress[indexPath.row]
        let place = MyPlace.init(name: address.addressName, lat: Double(address.x)!, lon: Double(address.y)!)
        
            NotificationCenter.default.post(name: Notification.Name("setAddress"), object: place)
            self.dismiss(animated: true)
        
    }
}
