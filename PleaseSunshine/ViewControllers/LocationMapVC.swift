//
//  LocationMapVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 27..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
struct MyPlace {
    var name: String
    var lat: Double
    var lon: Double
    var angle: Int
}
class LocationMapVC: UIViewController, NMapViewDelegate, NMapPOIdataOverlayDelegate, NMapLocationManagerDelegate, MMapReverseGeocoderDelegate{
    
    @IBOutlet weak var naviItem: UINavigationItem!
    var angel = 0
    let rotateAnglePerClick:CGFloat = 30
    var previousAngle:CGFloat = 0
    var hasInit = false
    @IBOutlet weak var mapParentView: UIView!
    @IBOutlet weak var searchAddressBtn: UIButton!
    @IBOutlet weak var setAddressBtn: UIButton!
    @IBOutlet weak var addressTxF: UITextField!
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    var mapView: NMapView?
    var changeStateButton: UIButton?
    let ud = UserDefaults.standard
    var choosenPlace: MyPlace?  {
        didSet {
            self.addressTxF.text = choosenPlace?.name
        }
    }
    var first = false
    var step = 1 {
        didSet {
            changeStep()
        }
    }
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    var currentState: state = .disabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        rotateView.isHidden = true
//        buttonClicked(UIButton())
        self.navigationController?.navigationBar.isTranslucent = false
        
        mapView = NMapView(frame: self.mapParentView.frame)
        
        if let mapView = mapView {
            
            // set the delegate for map view
            mapView.delegate = self
            mapView.reverseGeocoderDelegate = self
            // set the application api key for Open MapViewer Library
            mapView.setClientId("rvqftUnXa3kt18loah1K")
            
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapParentView.addSubview(mapView)
            
            mapView.translatesAutoresizingMaskIntoConstraints = false
            
            let bottom = mapView.bottomAnchor.constraint(equalTo: mapParentView.bottomAnchor)
            let top = mapView.topAnchor.constraint(equalTo: mapParentView.topAnchor)
            let leading = mapView.leadingAnchor.constraint(equalTo: mapParentView.leadingAnchor)
            let trailing = mapView.trailingAnchor.constraint(equalTo: mapParentView.trailingAnchor)
            mapParentView.addConstraints([top, bottom, leading, trailing])
            
        }
        
        // Add Controls.
        changeStateButton = createButton()
        
        if let button = changeStateButton {
            mapParentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            let bottom = button.bottomAnchor.constraint(equalTo: mapParentView.bottomAnchor, constant: -90)
            let trailing = button.trailingAnchor.constraint(equalTo: mapParentView.trailingAnchor, constant: -20)
            mapParentView.addConstraints([bottom, trailing])
        }
        // 주소 검색
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(addressGetter), name: NSNotification.Name("setAddress") , object: nil)
        
    }
    
    @objc func addressGetter(notification:Notification) {
        if let place = notification.object as? MyPlace{
            self.choosenPlace = place
            let point = NGeoPoint(longitude: place.lon, latitude: place.lat)
            print(point)
            mapView?.setMapCenter(point, atLevel: 20)
            requestAddressByCoordination(point)
        }
    }
    
    @IBAction func clickedClose(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func changeStep(){
        if step == 1 {
            rotateView.isHidden = true
            setAddressBtn.setTitle("이 위치로 주소 설정", for: .normal)
        } else if step == 2 {
            rotateView.isHidden = false
            setAddressBtn.setTitle("이 방향으로 방향 설정", for: .normal)
            if let place = choosenPlace {
                print("dfsdfsdeerwerwefds")
                print(place)
                mapView?.setMapCenter(NGeoPoint(longitude: place.lon, latitude: place.lat), atLevel: 20)
                clearOverlay()
                
            }
            
        } else {
            setAddressBtn.setTitle("여기서 계산하기", for: .normal)
            leftBtn.isHidden = true
            rightBtn.isHidden = true
            
        }
    }
    
    private func setupView() {
        let imgv = UIImageView(image: #imageLiteral(resourceName: "logo"))
        self.naviItem.titleView = imgv
        searchAddressBtn.applyRadius(radius: searchAddressBtn.frame.size.height/2)
        setAddressBtn.applyRadius(radius: 10)
        
    }
    @IBAction func leftButtonClicked(_ sender: UIButton) {
        if let mapView = mapView {
            
            if mapView.isAutoRotateEnabled == false {
                mapView.setAutoRotateEnabled(true, animate: true)
            }
            
            let newAngle = mapView.rotateAngle - rotateAnglePerClick// + (mapView.rotateAngle < rotateAnglePerClick ? 360 : 0)
            if let angle = choosenPlace?.angle {
                let changedAngle = angle - Int(rotateAnglePerClick)
                if changedAngle < 0 {
                    choosenPlace?.angle = changedAngle + 360
                } else {
                    choosenPlace?.angle = changedAngle
                }
                print(choosenPlace?.angle)
            }
            
            mapView.setRotateAngle(Float(newAngle), animate: true)
        }
    }
    
    @IBAction func rightButtonClicked(_ sender: UIButton) {
        if let mapView = mapView {
            
            if mapView.isAutoRotateEnabled == false {
                mapView.setAutoRotateEnabled(true, animate: true)
            }
            
            let newAngle = mapView.rotateAngle + rotateAnglePerClick// - (mapView.rotateAngle > 360 - rotateAnglePerClick ? 360 : 0)
            if let angle = choosenPlace?.angle {
                let changedAngle = angle + Int(rotateAnglePerClick)
                if changedAngle >= 360 {
                    choosenPlace?.angle = changedAngle - 360
                } else {
                    choosenPlace?.angle = changedAngle
                }
                print(choosenPlace?.angle)
            }
            mapView.setRotateAngle(Float(newAngle), animate: true)
        }
    }
    @IBAction func searchAddressClicked(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Address", bundle: nil).instantiateViewController(withIdentifier: "LocationSearchVC") as! LocationSearchVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func setAddressAction(_ sender: UIButton) {
        if step == 3 {
            if let place = choosenPlace {
                NotificationCenter.default.post(name: NSNotification.Name("setAddress"), object: place)
                ud.set(place.lat, forKey: "latitude")
                ud.set(place.lon, forKey: "longitude")
                ud.set(place.name, forKey: "name")
                ud.set(place.angle, forKey: "angle")
                self.dismiss(animated: true)
            }
            
        }
        step = step + 1
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if view.frame.size.width != size.width {
            if let mapView = mapView, hasInit, mapView.isAutoRotateEnabled {
                previousAngle = mapView.rotateAngle
                mapView.setAutoRotateEnabled(false, animate: false)
                
                coordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext) -> Void in
                    if let mapView = self.mapView, self.hasInit {
                        mapView.setAutoRotateEnabled(true, animate: false)
                        mapView.setRotateAngle(Float(self.previousAngle), animate: true)
                    }
                }, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        mapView?.viewDidDisappear()
    }
    
    // MARK: - NMapViewDelegate Methods
    
    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            enableLocationUpdate()
//            mapView.setMapCenter(NGeoPoint(longitude:126.978371, latitude:37.5666091), atLevel:11)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
            hasInit = true
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    // 이동 가능한 마커 추가
    open func onMapView(_ mapView: NMapView!, touchesEnded touches: Set<AnyHashable>!, with event: UIEvent!) {
        
        if let touch = event.allTouches?.first {
            // Get the specific point that was touched
            let scrPoint = touch.location(in: mapView)
            
            print("scrPoint: \(scrPoint)")
            print("to: \(mapView.fromPoint(scrPoint))")
            requestAddressByCoordination(mapView.fromPoint(scrPoint))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView?.viewWillDisappear()
        
        stopLocationUpdating()
    }
    
    // MARK: - NMapPOIdataOverlayDelegate Methods
   
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected);
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint.zero
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    
    // MARK: - MMapReverseGeocoderDelegate Methods // 이동 가능한 마커
    
    open func location(_ location: NGeoPoint, didFind placemark: NMapPlacemark!) {
        print("didFind")
        let address = placemark.address
        
        addressTxF.text = address
        let place = MyPlace(name: address!, lat:location.latitude, lon: location.longitude, angle: 0)
        choosenPlace = place
//        let alert = UIAlertController(title: "ReverseGeocoder", message: address, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
    }
    
    open func location(_ location: NGeoPoint, didFailWithError error: NMapError!) {
        print("location:(\(location.longitude), \(location.latitude)) didFailWithError: \(error.description)")
    }

    
    // MARK: -
    
    func requestAddressByCoordination(_ point: NGeoPoint) {
        mapView?.findPlacemark(atLocation: point)
//        mapView?.setMapCenter(point, atLevel: 20)
        setMarker(point)
    }
    
    let UserFlagType: NMapPOIflagType = NMapPOIflagTypeReserved + 1
    
    func setMarker(_ point: NGeoPoint) {
        
        clearOverlay()
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(1)
                
                poiDataOverlay.addPOIitem(atLocation: point, title: "마커 1", type: UserFlagType, iconIndex: 0, with: nil)
                
                poiDataOverlay.endPOIdata()
            }
        }
    }
    
    func clearOverlay() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            mapOverlayManager.clearOverlay()
        }
    }
    // MARK: - NMapLocationManagerDelegate Methods
    
    open func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        if !first {
            updateState(.disabled)
             stopLocationUpdating()
        }
        let coordinate = location.coordinate
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
//        let locationAccuracy = Float(location.horizontalAccuracy)
        addressTxF.text = ""
        let place = MyPlace(name: "", lat:coordinate.latitude, lon: coordinate.longitude, angle: 0)
        choosenPlace = place
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: 0)
        mapView?.setMapCenter(myLocation, atLevel: 20)
        setMarker(myLocation)
    }
    
    open func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        if !first {
            updateState(.disabled)
            stopLocationUpdating()
        }
        print("didFailWithE")
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        print("didupdate")
        if !first {
            updateState(.disabled)
            stopLocationUpdating()
        }
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        if !first {
            updateState(.disabled)
            stopLocationUpdating()
        } else {
        enableLocationUpdate()
        }
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 15, y: 30, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
//        if let lm = NMapLocationManager.getSharedInstance() {
        
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                stopLocationUpdating()
                updateState(.disabled)
//                let isAvailableCompass = lm.headingAvailable()
//
//                if isAvailableCompass {
//                    enableLocationUpdate()
//                    if enableHeading() {
//                        updateState(.trackingWithHeading)
//                    }
//                } else {
//                    stopLocationUpdating()
//                    updateState(.disabled)
//                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
//        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
}
