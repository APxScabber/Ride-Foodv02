//
//  CalculatingPathManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 19.08.2021.
//

import MapKit
import CoreLocation

class CalculatingPathManager {
    
    //Расчет маршрута
    func calculatingPath(for map: MKMapView) {
        
        map.removeOverlays(map.overlays)
        
        var fromPoint: CLLocationCoordinate2D?
        var toPoint: CLLocationCoordinate2D?
        
        for mark in map.annotations {
            if mark.title == "From" {
                fromPoint = mark.coordinate
            } else if mark.title == "To" {
                toPoint = mark.coordinate
            }
        }
            
        guard let fromPoint = fromPoint, let toPoint = toPoint else { return }
        
        let start = MKPlacemark(coordinate: fromPoint)
        let end = MKPlacemark(coordinate: toPoint)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: start)
        request.destination = MKMapItem(placemark: end)
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            guard let response = response else { return }
            for route in response.routes {
                map.addOverlay(route.polyline)
            }
        }
    }
}
