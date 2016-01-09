//
//  ViewController.swift
//  My Coordinates
//
//  Created by Kyle Haptonstall on 1/8/16.
//  Copyright © 2016 Kyle Haptonstall. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    
    // MARK: - Global Variables
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()

    var markerOnMap = false

    // MARK: - Storyboard Labels
    @IBOutlet weak var latLabel: UILabel!
    
    @IBOutlet weak var longLabel: UILabel!
    
    
    // MARK: - Nav Bar Buttons
    
    /**
        Clears the map of all markers and resets the center to the
        user's current location
    
        - parameter sender: Left nav bar button
    */
    @IBAction func resetMap(sender: UIButton) {
        mapView.clear()
        
        markerOnMap = false
        
        self.mapView.camera = GMSCameraPosition(target: (locationManager.location?.coordinate)!, zoom: 12, bearing: 0, viewingAngle: 0)
        
        self.mapView.myLocationEnabled = true
        
        self.latLabel.text = String(locationManager.location!.coordinate.latitude)
        self.longLabel.text = String(locationManager.location!.coordinate.longitude)
    }
    

    /**
        Grabs the current latitude and longitude and allows the user to share
     
        - parameter sender: Right nav bar button
     */
    @IBAction func shareButtonPressed(sender: AnyObject) {
        let currLat = latLabel.text
        let currLong = longLabel.text
        
        if currLat != nil && currLong != nil{
            let activityController = UIActivityViewController(activityItems: ["My current lattitude is: \(currLat!), and current longitude is: \(currLong!)"], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)

        }
            }
    
    

    // MARK: - View Controller Methods
    override func viewDidAppear(animated: Bool) {
        if CLLocationManager.locationServicesEnabled() == false{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    
    // MARK: - Custom Methods
    func setUpNavBar(){
        let logoView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        logoView.image = UIImage(named: "MyCoordinateLogo") 
        logoView.frame.origin.x = (self.view.frame.size.width - logoView.frame.size.width) / 2
        logoView.frame.origin.y = 25
        
        self.navigationController?.view.addSubview(logoView)
        
        self.navigationController?.view.bringSubviewToFront(logoView)
    }
    
   
   
    // MARK: - MapView Delegate Methods
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if markerOnMap == false { markerOnMap = true }
        
        self.latLabel.text = String(coordinate.latitude)
        self.longLabel.text = String(coordinate.longitude)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.clear()
        self.mapView.myLocationEnabled = false
        marker.map = self.mapView
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != .AuthorizedWhenInUse {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if markerOnMap == false{
            let locationArr = locations as NSArray
            let locationObj = locationArr.lastObject as! CLLocation
            let coordinate = locationObj.coordinate
            self.mapView.camera = GMSCameraPosition(target: (coordinate), zoom: 12, bearing: 0, viewingAngle: 0)
            self.mapView.myLocationEnabled = true
            
            self.latLabel.text = String(coordinate.latitude)
            self.longLabel.text = String(coordinate.longitude)
            self.markerOnMap = true
        }
    }
}