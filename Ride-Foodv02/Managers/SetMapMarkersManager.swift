//
//  TaxiMainInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.08.2021.
//
import CoreLocation
import UIKit
import MapKit

class SetMapMarkersManager {
    
    static let shared = SetMapMarkersManager()
    
    var isFromAddressMarkSelected = true
    var isPathCalculeted = false
    
    private init() {
    }
    
    // Выставляем метку на карте относительно указанным координатам
    func setMarkOn(map: MKMapView, with coordinate: CLLocationCoordinate2D, completion: @escaping ((String) -> ())) {
        
        if isFromAddressMarkSelected {
            
            _ = map.annotations.compactMap { mark in
                if mark.title == "From" {
                    map.removeAnnotation(mark)
                }
            }
        } else {
            _ = map.annotations.compactMap { mark in
                if mark.title == "To" {
                    map.removeAnnotation(mark)
                }
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = isFromAddressMarkSelected ? "From" : "To"
        map.addAnnotation(annotation)
        map.fitAllAnnotations()
        CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).findAddress { address in
            completion(address)
            self.isFromAddressMarkSelected = true
        }
        if isPathCalculeted {
            CalculatingPathManager.shared.calculatingPath(for: map)
        }
        
        MapKitManager.shared.locationManager.stopUpdatingLocation()
    }
}
