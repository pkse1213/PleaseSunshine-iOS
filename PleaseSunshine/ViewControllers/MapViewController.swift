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
    
    @IBOutlet weak var mapView: GMSMapView!
    //    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
   
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.last {
            
            let camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
//            locationManager.stopUpdatingLocation()
            originCoordinate = location.coordinate
            
            // 처음 뷰가 떴을 때만 현재위치로 핀을 꽂는다
            if mapView.isHidden {
                let marker = GMSMarker()
                marker.position  = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                marker.appearAnimation = GMSMarkerAnimation.pop
                marker.icon = #imageLiteral(resourceName: "pin")
                marker.map = mapView
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
        }
//        if let location = locations.first {  }
    }
    
    
    func currentLocationMarker(){

        let origin = GMSMarker(position: originCoordinate)
        origin.map = self.mapView
    }
}
