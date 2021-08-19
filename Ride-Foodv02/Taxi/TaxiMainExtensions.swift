  
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
            
            MapKitManager.shared.currentUserCoordinate = loc
            
            taxiMainInteractor.setMarkOnMap(map: mapView, with: loc) { address in
                self.fromAddress = address
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
    
   // Задаем внещний вид маркеров для позиции от куда едем и куда
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let currentAnnotation = taxiMainInteractor.isFromAddressMarkSelected
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
