//
//  MapViewController.swift
//  testTask3
//
//  Created by Краснов Андрей on 22.05.16.
//  Copyright © 2016 Краснов Андрей. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController {
    @IBOutlet weak var map: MKMapView!
    var latitude : Double = 0
    var spnLatitude : Double = 0
    var longitude : Double = 0
    var spnLongitude : Double = 0
    var cityName : String = ""
    
    override func viewDidLoad() {
        let initialLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        centerMapOnLocation(initialLocation)
    }

    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: spnLatitude, longitudeDelta: spnLongitude))
        map.setRegion(coordinateRegion, animated: true)
        let marker = MKPointAnnotation()
        marker.coordinate = location
        marker.title = cityName
        map.addAnnotation(marker)
    }
}
