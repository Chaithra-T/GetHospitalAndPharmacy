//
//  PlaceAnnotation.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 14/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    
    /*
    This property is declared with `@objc dynamic` to meet the API requirement that the coordinate property on all MKAnnotations
    must be KVO compliant.
     */
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var url: URL?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
