//
//  TaxiMainInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 16.08.2021.
//
import CoreLocation
import UIKit
import MapKit

class TaxiMainInteractor {
    
    var isFromAddressMarkSelected = true
    var isPathCalculeted = false
    
    // Загрузка адресов с сервера с последующим сохранением в Core Data
    func getAdressesFromServer(view: UIViewController) {
        
        AddressesNetworkManager.shared.getTheAddresses { result in
            
            switch result {
            case .success(let adressesData):
    
                PersistanceManager.shared.createCoreDataInstance(addressesToCopy: adressesData, view: view)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //Получаем координаты из прописного адреса
    func getCoordinates(from address: String, to map: MKMapView, completion: @escaping ((String) -> ())) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
            
            self.setMarkOnMap(map: map, with: location.coordinate) { address in
                completion(address)
            }
        }
    }
    
    // Выставляем метку на карте относительно указанным координатам
    func setMarkOnMap(map: MKMapView, with coordinate: CLLocationCoordinate2D, completion: @escaping ((String) -> ())) {
        
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
            calculatingPath(for: map)
        }
        
        MapKitManager.shared.locationManager.stopUpdatingLocation()
    }
    
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
