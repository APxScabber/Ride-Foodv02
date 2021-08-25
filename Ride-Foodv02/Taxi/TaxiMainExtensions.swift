//
//  TaxiMainExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 17.08.2021.
//
import MapKit
import CoreLocation

extension TaxiMainVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Получаем координаты пользователя при активной locationManager.startUpdatingLocation()
        if let loc = manager.location?.coordinate {
            
            SetMapMarkersManager.shared.setMarkOn(map: mapView, with: loc) { address in
                self.fromAddress = address
                MapKitManager.shared.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    //Если пользователь изменил настройки авторизации, то проверяем заново
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        MapKitManager.shared.checkAuthorization(view: self)
    }
}

//MARK: - MapViewDelegate

extension TaxiMainVC: MKMapViewDelegate {
    
    //Задаем внещний вид маркеров для позиции от куда едем и куда
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let currentAnnotation = SetMapMarkersManager.shared.isFromAddressMarkSelected
        let imageAnnotation = currentAnnotation ? UIImage(named: "Annotation") : UIImage(named: "OrangeAnnotation")
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = imageAnnotation
        annotationView.frame.size = CGSize(width: 30, height: 48)

        return annotationView
    }
    
    //Задаем внешний вид линии траектории рассчитанного марщрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [
          UIColor(red: 0.239, green: 0.231, blue: 1, alpha: 1).cgColor,
          UIColor(red: 0.984, green: 0.557, blue: 0.314, alpha: 1).cgColor
        ]

        render.strokeColor = .blue
        render.lineWidth = 4

        return render
    }
}

extension TaxiMainVC: SetMapMarkersDelegate {
    
    func zoomAllMarketsOnMap() {
        if mapView.annotations.count < 2 {
            guard let coordinate = MapKitManager.shared.currentUserCoordinate else { return }
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(region, animated: true)
        } else {
            mapView.fitAllAnnotations(with: UIEdgeInsets(top: 100, left: 50, bottom: 50 + addressesChooserView.frame.height, right: 50))
        }
    }
    
    func pathTime(minutes: Int) {
        timeLabel.text = "≈\(minutes) \(Localizable.Taxi.minutes.localized)"
        pathTimeView.alpha = 1
    }
}
