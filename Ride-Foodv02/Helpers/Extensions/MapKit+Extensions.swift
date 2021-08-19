//
//  MapKit+Extensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 18.08.2021.
//
import MapKit


extension MKMapView {
    
    func fitAllAnnotations(with padding: UIEdgeInsets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let annotationPoint = MKMapPoint($0.coordinate)
            //let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 100, height: 100)
            let pointRect = MKMapRect(origin: annotationPoint, size: MKMapSize(width: 5000, height: 5000))
            zoomRect = zoomRect.union(pointRect)
        })
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
    
    func fit(annotations: [MKAnnotation], andShow show: Bool, with padding: UIEdgeInsets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)) {
        var zoomRect: MKMapRect = .null
        annotations.forEach({
            let aPoint = MKMapPoint($0.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.isNull ? rect : zoomRect.union(rect)
        })
        
        if show {
            addAnnotations(annotations)
        }
        
        setVisibleMapRect(zoomRect, edgePadding: padding, animated: true)
    }
}
