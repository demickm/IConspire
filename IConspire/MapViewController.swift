//
//  MapViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 7/4/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
   
    
    @IBOutlet weak var mapView: MKMapView!
        var support: [Support]?
    
        var locationManager: CLLocationManager = CLLocationManager()
        var eventLocation: CustomAnnotations?
        var eventLocations: [CustomAnnotations] = []
        var currentLocation: CustomAnnotations?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            mapView.delegate = self
            mapView.showsUserLocation = true
            guard let supportLocations = support else {return}
            for locations in supportLocations {
                let supportLatitude = locations.supportLatitude
                let supportLongitude = locations.supportLongitude
                let supportTitle = locations.supportTitle
                eventLocation = CustomAnnotations(latitude: supportLatitude, longitude: supportLongitude, name: supportTitle)
                guard let eventLocation = eventLocation else {return}
                
                eventLocations.append(eventLocation)

                mapView.showAnnotations(eventLocations, animated: true)

            }
            locationManager.stopUpdatingLocation()
    }
    
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let location = locations.last {
                let string = "latitude: \(location.coordinate.latitude) longitude: \(location.coordinate.longitude)"
                print(string)
                
                let locationAnnotation = CustomAnnotations(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, name: "My Location")
                
                if let eventLocation = eventLocation {
                    mapView.showAnnotations([eventLocation, locationAnnotation], animated: true)
                }
            }
        }
  
    class CustomAnnotations: NSObject, MKAnnotation {
        
        var latitude: Double
        var longitude: Double
        var name: String
        
        init(latitude: Double, longitude: Double, name: String) {
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
        }
        
        var coordinate: CLLocationCoordinate2D {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return coordinate
        }
        var title: String? {
            return name
        }
    }

}

