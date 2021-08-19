//
//  CLLocationCoordinate2D+Extensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 19.08.2021.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
