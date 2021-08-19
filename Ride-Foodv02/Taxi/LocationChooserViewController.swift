import UIKit
import MapKit
import CoreLocation

protocol LocationChooserDelegate: AnyObject {
    func locationChoosen(_ newLocation:String)
}

class LocationChooserViewController: UIViewController {

    //MARK: - API
    
    var region = MKCoordinateRegion()
    let taxiMainInteractor = TaxiMainInteractor()
    
    var location = String() { didSet {
        locationLabel?.text = location
        confirmButton?.isUserInteractionEnabled = !location.isEmpty
        roundedView?.colorToFill = location.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    weak var delegate: LocationChooserDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView! { didSet {
        mapView.setRegion(region, animated: false)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTouched(_:))))
        mapView.delegate = self
    }}
    @IBOutlet weak var locationImageView: UIImageView! { didSet {
        locationImageView.isHidden = true
    }}
    @IBOutlet weak var locationLabel: UILabel! { didSet {
        locationLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = location.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    @IBOutlet weak var twoCornerRoundedView: TopRoundedView!
    
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        confirmButton.isUserInteractionEnabled = !location.isEmpty
        confirmButton.setTitle(Localizable.Food.confirm.localized, for: .normal)
    }}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taxiMainInteractor.isFromAddressMarkSelected = false
        taxiMainInteractor.getCoordinates(from: location, to: mapView) { address in
            self.location = address
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        delegate?.locationChoosen(location)
        dismiss(animated: true)
    }
    
    //MARK: - Location chooser
    
    @objc
    private func mapViewTouched(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            mapView.removeAnnotations(mapView.annotations)
            
            let location = recognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).findAddress { [weak self] in
                self?.location = $0
                self?.locationImageView.isHidden = false
            }
        }
    }
}

//MARK: - MapViewDelegate

extension LocationChooserViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = UIImage(named: "OrangeAnnotation")
        annotationView.frame.size = CGSize(width: 30, height: 48)
        return annotationView
    }
}
