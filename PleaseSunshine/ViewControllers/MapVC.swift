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

struct MyPlace {
    var name: String
    var lat: Double
    var lon: Double
}
class MapVC: UIViewController, UISearchDisplayDelegate {
    let ud = UserDefaults.standard
    
    var choosenPlace: MyPlace?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var originCoordinate: CLLocationCoordinate2D!
    var placesClient: GMSPlacesClient!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchAddressBtn: UIButton!
    @IBOutlet weak var setAddressBtn: UIButton!
    
    // 주소검색
   @IBOutlet weak var addressTxF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addressTxF.delegate = self
        
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
        
        // 주소 검색
        
    }
        
    @IBAction func searchAddressClicked(_ sender: UIButton) {
////
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)

    }
    
    @IBAction func setAddressAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("setAddress"), object: [1.0,2.0])
        ud.set(1.0, forKey: "latitude")
        ud.set(1.0, forKey: "longitude")
        self.dismiss(animated: true)
    }
    
    private func setupView() {
        searchAddressBtn.applyRadius(radius: searchAddressBtn.frame.size.height/2)
        setAddressBtn.applyRadius(radius: 10)
        
    }
}
extension MapVC: CLLocationManagerDelegate {
    
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

extension MapVC: GMSAutocompleteViewControllerDelegate, UITextFieldDelegate, GMSMapViewDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
//        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true) {
            
        }
        return false
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
        mapView.camera = camera
        addressTxF.text = place.formattedAddress
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress)"
        marker.icon = #imageLiteral(resourceName: "pin")
        marker.map = mapView
        self.dismiss(animated: true) {
            self.choosenPlace = MyPlace(name: "\(place.formattedAddress)", lat: lat, lon: lon)
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
