//
//  SelectLocationVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 30.07.2021.
//

import UIKit
import MapKit
import CoreLocation

protocol SetLocationDelegate: AnyObject {
    func locationIsSet(location: String)
}

class SelectLocationVC: UIViewController {
    
    var previousLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var locationRegion = MKCoordinateRegion()
    
    var regionZoomInMeters: Double = 10000
    
    weak var delegate: SetLocationDelegate?
    
    var locationText = String() { didSet{
        locationLabel.text = locationText
        confirmButton.isUserInteractionEnabled = !locationText.isEmpty
        ConfirmButtonBackgroundView.backgroundColor = locationText.isEmpty ? UIColor.DisabledButtonBackgroundView : UIColor.SkillboxIndigoColor
        locationPlacemarkImageView.isHidden = locationText.isEmpty
        
    }}
    
    @IBOutlet weak var mapview: MKMapView! { didSet{
//        mapview.setRegion(locationRegion, animated: true)
//        mapview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnMapView)))
        mapview.delegate = self
    }}
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var addressInformationBackgroundView: UIView! { didSet{
        
    }}

    @IBOutlet weak var ConfirmButtonBackgroundView: UIView! { didSet{
        
        ConfirmButtonBackgroundView.backgroundColor = locationText.isEmpty ? UIColor.DisabledButtonBackgroundView : UIColor.SkillboxIndigoColor
   
    }}
    
    @IBOutlet weak var confirmButton: UIButton! { didSet{
        
    }}
    
    @IBOutlet weak var locationPlacemarkImageView: UIImageView! { didSet{
        locationPlacemarkImageView.isHidden = locationText.isEmpty
        
    }}
    
    @IBOutlet weak var locationLabel: UILabel! { didSet{
        
    }}
    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setLabelAndImageBehaviour()
        setButtonBehavior()
        setLocationBackgroundView()
        getTheDecodedAddress(mapView: mapview)
        
        // Do any additional setup after loading the view.
    }
    
//    permission functions
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationuthorization()
            centerViewOnUserLocation()
        } else {
            
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionZoomInMeters, longitudinalMeters: regionZoomInMeters)
            mapview.setRegion(region, animated: true)
        }
    }
    
    func startTrackingUserLocation(){
        centerViewOnUserLocation()
        mapview.showsUserLocation = true
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapview)
    }
    
    func checkLocationuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .authorizedAlways:
            startTrackingUserLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case.restricted:
            break
        default:
            break
        }
    }
    
//    configureUI
    
    func setLocationBackgroundView(){
        addressInformationBackgroundView.backgroundColor = .white
        addressInformationBackgroundView.layer.cornerRadius = 15.0
        addressInformationBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func setLabelAndImageBehaviour(){
        locationPlacemarkImageView.isHidden = locationText.isEmpty
        
    }
    
    func setButtonBehavior(){
        ConfirmButtonBackgroundView.layer.cornerRadius = 15
        
        
        confirmButton.setTitle("Выбрать адрес", for: .normal)
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        confirmButton.isUserInteractionEnabled = locationText.isEmpty
        
        
       
    }
    
    
    @IBAction func popViewController(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        delegate?.locationIsSet(location: locationText)
    
        self.dismiss(animated: true)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let latitude = mapview.centerCoordinate.latitude
        let longitude = mapview.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getTheDecodedAddress(mapView: MKMapView){
        let center = getCenterLocation(for: mapview)
         let geocoder = CLGeocoder()
         
         
         
         geocoder.reverseGeocodeLocation(center) { [weak self] placemarks, error in
             guard let self = self else {return}
             if let _ = error {
                 print("Ошибка")
                 return
             }
             
             guard let placeMark = placemarks?.first else {
                 print("Something happened")
                 return
             }
             
             let city = placeMark.locality ?? ""
             let streetName = placeMark.thoroughfare ?? ""
             let streetNumber = placeMark.subThoroughfare ?? ""
             
             let street = "\(city) \(streetName) \(streetNumber)"
             
             DispatchQueue.main.async {
                 self.locationText = street
             }
             
         }
     }
     
}

extension SelectLocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapview)
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 100 else { return }
      getTheDecodedAddress(mapView: mapview)

    
}
}

extension SelectLocationVC: CLLocationManagerDelegate{
   
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationuthorization()
    }
}


