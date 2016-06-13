//
//  ViewController.swift
//  GeoTargeting
//
//  Created by 白 云鹏 on 16/6/3.
//  Copyright © 2016年 baiyunpeng.com. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol RegionProtocol {
    var coordinate: CLLocation {get}
    var radius: CLLocationDistance {get}
    var identifier: String {get}
    
    func updateRegion()
}

protocol RegionDelegateProtocol {
    func didEnterRegion()
    func didExitRegion()
}

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // 1. create locationManager
    var locationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2. setup locationManager
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 3. setup mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow
        
        // 4. setup test data
        setupData()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .Denied {
            let alertView = UIAlertView(title: "标题", message: "这个是UIAlertView的默认样式", delegate: self, cancelButtonTitle: "取消")
            alertView.show()
            //showAlert("Location services were previously denied.");
        }
        else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        } 
    }
    
    
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            
            // 2. region data
            let title = "Lorrenzillo' s"
            let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
            let resionRadius = 300.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: resionRadius, identifier: title)
            
            // 4. setup annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            self.mapView.addAnnotation(restaurantAnnotation)
            
            // 5. setup circle
            let circle = MKCircle(centerCoordinate: coordinate, radius: resionRadius)
            self.mapView.addOverlay(circle)
        }
        else {
            print("System can't track regions")
        }
        
        // 6. draw circle
        func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.redColor()
            circleRenderer.lineWidth = 1.0
            return circleRenderer
        }
    }
    
    
    var monitoredRegions: Dictionary<String, NSDate> = [:]
    // 1. user enter region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alertView = UIAlertView(title: "标题", message: "这个是UIAlertView的默认样式", delegate: self, cancelButtonTitle: "取消")
        alertView.show()
        //showAlert("enter" \(region.identifier)")
        
        // 2.1 Add entrance time
        monitoredRegions[region.identifier] = NSDate()
    }
    

    // 2. user exit region
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alertView = UIAlertView(title: "标题", message: "这个是UIAlertView的默认样式", delegate: self, cancelButtonTitle: "取消")
        alertView.show()
        //showAlert("exit \(region.identifier)")
        
        // 2.2 Remove entrance time
        monitoredRegions.removeValueForKey(region.identifier)
    }
    
    // 3. Update resions logic
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegions()
    }
    
    func updateRegions() {
        // 1. 
        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []
        
        //2.
        for regionIdentifier in monitoredRegions.keys {
            //3.
            if NSDate().timeIntervalSinceDate(monitoredRegions[restorationIdentifier!]!) > regionMaxVisiting {
                let alertView = UIAlertView(title: "标题", message: "这个是UIAlertView的默认样式", delegate: self, cancelButtonTitle: "取消")
                alertView.show()
                //showAlert("Thanks for visiting our restaurant")
                
                regionsToDelete.append((regionIdentifier))
            }
            
            // 4.
            for regionIdentifier in regionsToDelete {
                monitoredRegions.removeValueForKey(regionIdentifier)
            }
        }
    }

    
    

    
}

