//
//  SearchAddressVC.swift
//  PleaseSunshine
//
//  Created by 박세은 on 2018. 11. 23..
//  Copyright © 2018년 박세은. All rights reserved.
//
import UIKit
import Foundation
import GooglePlaces
import GoogleMaps


class ViewController: UIViewController,GMSAutocompleteViewControllerDelegate,UISearchControllerDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var searchBar: UISearchBar?
    var tableDataSource: GMSAutocompleteTableDataSource?
    var googleMapsView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialization()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        googleMapsView = GMSMapView(frame: self.view.frame)
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        self.view.addSubview(googleMapsView)
    }
    func initialization(){
        resultsViewController = GMSAutocompleteResultsViewController()
        //  resultsViewController?.delegate = ViewController
        
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        //searchController
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        navigationController?.navigationBar.isTranslucent = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        //searchController.
        // This makes the view area include the nav bar even though it is opaque.
        // Adjust the view placement down.
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        
        self.view.addSubview((searchController?.view)!)
        self.view.addSubview((resultsViewController?.view)!)
        
    }
    
    
    
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        // let secondVC : UIViewController = UIViewController()
        let autocompleteController = GMSAutocompleteViewController()
        // autocompleteController.delegate = self
        //  self.navigationController?.pushViewController(autocompleteController, animated: true)
        
        // present(autocompleteController, animated: true, completion: nil)
    }
    
    //MARK:- GMSAutocompleteViewControllerDelegate delegate method
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress!)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        
        /* let correctedAddress:String! = self.searchResults[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.symbolCharacterSet())
         let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(searchBar?.text)&sensor=false")
         
         let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
         // 3
         do {
         if data != nil{
         let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  NSDictionary
         
         let lat = ((dic["results"] as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location")?.valueForKey("lat")?.objectAtIndex(0) as! Double
         let lon
         
         
         = (((dic["results"] as AnyObject).value(forKey: "geometry") as AnyObject).value(forKey: "location")? as AnyObject).valueForKey("lng")?.objectAtIndex(0) as! Double
         // 4
         self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row] )
         }
         }catch {
         print("Error")
         }
         }
         // 5
         task.resume()*/
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
