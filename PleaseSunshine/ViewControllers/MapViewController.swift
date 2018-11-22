//
//  MapViewController.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 22..
//  Copyright © 2018년 박세은. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var originCoordinate: CLLocationCoordinate2D!
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchAddressBtn: UIButton!
    @IBOutlet weak var addressTxF: UITextField!
    @IBOutlet weak var setAddressBtn: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        mapView.isHidden = true
        
    }
    
    private func setupView() {
        searchAddressBtn.applyRadius(radius: searchAddressBtn.frame.size.height/2)
        setAddressBtn.applyRadius(radius: 10)
        
    }
}
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 10)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
//            locationManager.stopUpdatingLocation()
//            originCoordinate = location.coordinate
            
            // 처음 뷰가 떴을 때만 현재위치로 핀을 꽂는다
            if mapView.isHidden {
                
                let locationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                
                showMarker(locationCoordinate: locationCoordinate)
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
//        if let location = locations.first {  }
    }
    
    
    func showMarker(locationCoordinate: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position  = locationCoordinate
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = #imageLiteral(resourceName: "pin")
        marker.map = mapView
    }
}
