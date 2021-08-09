import UIKit
import MapKit
import CoreLocation

class TaxiMainVC: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView! { didSet {
        let center = CLLocationCoordinate2D(latitude: 55.7520, longitude: 37.6175)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTouched(_:))))
        mapView.delegate = self
    }}
   
    private let addressesChooserView = AddressesView.initFromNib()
    
    //MARK: - Actions
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressesChooserView.delegate = self
        view.addSubview(addressesChooserView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addressesChooserView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: TaxiConstant.addressesChooserViewHeight)
        pinAddressesTo(view.bounds.height - TaxiConstant.addressesChooserViewHeight)
    }
    
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
                self?.addressesChooserView.fromAddress = $0
            }
        }
    }
    
    private func pinAddressesTo(_ y:CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: TaxiConstant.durationForAppearingAddressesChooserView, delay: 0.0, options: .curveLinear) {
            self.addressesChooserView.frame.origin.y = y
        } completion: { if $0 == .end {}
        }

    }
    
}

//MARK: - MapViewDelegate

extension TaxiMainVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = UIImage(named: "Annotation")
        annotationView.frame.size = CGSize(width: 30, height: 48)
        return annotationView
    }
    
}

//MARK: - AddressesViewDelegate

extension TaxiMainVC: AddressesViewDelegate {
    
    func moveDown() {
        
    }
    
    func next() {
        
    }
    
    
}
