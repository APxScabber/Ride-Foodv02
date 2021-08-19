//
//  MapKitManager.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 19.08.2021.
//

import MapKit
import CoreLocation

class MapKitManager {
    
    static let shared = MapKitManager()
    
    var locationManager = CLLocationManager()
    var currentUserCoordinate: CLLocationCoordinate2D?
    
    init() {
    }
    
    
    private func setupLocationManager(delegate: CLLocationManagerDelegate) {
        
        MapKitManager.shared.locationManager.delegate = delegate
        MapKitManager.shared.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorization(view: UIViewController) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            
            MapKitManager.shared.locationManager.startUpdatingLocation()
        case .denied:
            
            settingsAlertController(title: "Определение местороложения запрещено",
                                                       message: "Разрешить?",
                                                       url: URL(string: UIApplication.openSettingsURLString),
                                                       view: view)
        case .notDetermined:
            
            MapKitManager.shared.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    func checkLocationServices(delegate: CLLocationManagerDelegate, view: UIViewController) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            setupLocationManager(delegate: delegate)
            checkAuthorization(view: view)
        } else {

            settingsAlertController(title: "Служба геолокации выключена",
                                                       message: "Включить?",
                                                       url: URL(string: "App-Prefs:root=LOCATION_SERVICES"),
                                                       view: view)
        }
    }
    
    private func settingsAlertController(title: String, message: String, url: URL?, view: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsButton = UIAlertAction(title: "Настройки", style: .default) { action in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(settingsButton)
        alertController.addAction(cancelButton)
        
        view.present(alertController, animated: true, completion: nil)
    }
}
