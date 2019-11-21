//
//  Storm.swift
//  SwiftSky
//
//  Created by Luca Silverentand on 11/04/2017.
//  Copyright © 2017 App Company.io. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    func destinationBy(_ distance: CLLocationDistance, direction: CLLocationDirection) -> CLLocation {
        let earthRadius     = 6372.7976
        let angularDistance = (distance / 1000) / earthRadius
        let originLatRad    = self.coordinate.latitude * (.pi / 180)
        let originLngRad    = self.coordinate.longitude * (.pi / 180)
        let directionRad    = direction * (.pi / 180)
        
        let destinationLatRad = asin(
            sin(originLatRad) * cos(angularDistance) +
                cos(originLatRad) * sin(angularDistance) *
                cos(directionRad))
        
        let destinationLngRad = originLngRad + atan2(
            sin(directionRad) * sin(angularDistance) * cos(originLatRad),
            cos(angularDistance) - sin(originLatRad) * sin(destinationLatRad))
        
        let destinationLat: CLLocationDegrees = destinationLatRad * (180 / .pi)
        let destinationLng: CLLocationDegrees = destinationLngRad * (180 / .pi)
        
        return CLLocation(latitude: destinationLat, longitude: destinationLng)
    }
}

/// Contains a `Bearing` and `Distance` describing the location of a storm
public struct Storm {
    
    /// `Bearing` from requested location where a storm can be found
    public let bearing : Bearing?
    
    /// `Distance` from requested location where a storm can be found
    public let distance : Distance?
    
    /// ``
    public let location : CLLocation?
    
    var hasData : Bool {
        if bearing != nil { return true }
        if distance != nil { return true }
        return false
    }
    
    init(bearing: Bearing?, distance: Distance?, origin: CLLocation?) {
        self.bearing = bearing
        self.distance = distance
        if bearing == nil || distance == nil || origin == nil {
            self.location = nil
        } else {
            self.location = origin?.destinationBy(Double(distance!.value(as: .meter)), direction: Double(bearing!.degrees))
        }
    }
    
}
