//
//  MapKit+Extensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 18.08.2021.
//

import MapKit


extension MKMapView {

    func fitAllAnnotations(with padding: UIEdgeInsets = UIEdgeInsets(top: 100, left: 50, bottom: 50, right: 50)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let annotationPoint = MKMapPoint($0.coordinate)
        
            let pointRect = MKMapRect(origin: annotationPoint, size: MKMapSize(width: 5000, height: 5000))
            zoomRect = zoomRect.union(pointRect)
        })
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
}
