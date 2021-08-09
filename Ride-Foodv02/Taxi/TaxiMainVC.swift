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
        NotificationCenter.default.addObserver(self, selector: #selector(moveAddressesChooserView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressesChooserView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: TaxiConstant.addressesChooserViewHeight)
        pinAddressesTo(view.bounds.height - TaxiConstant.addressesChooserViewHeight)
        addressesChooserView.shopMapItems(false)
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
    @objc
    private func moveAddressesChooserView(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.pinAddressesTo(self.view.bounds.height - size.height - TaxiConstant.addressesChooserViewHeight)
            addressesChooserView.shopMapItems(true)
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationChooser",
           let destination = segue.destination as? LocationChooserViewController {
            destination.delegate = self
            destination.region = mapView.region
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
        pinAddressesTo(view.bounds.height - TaxiConstant.addressesChooserViewHeight)
        addressesChooserView.shopMapItems(false)
    }
    
    func next() {
        
    }
    
    func showMap() {
        performSegue(withIdentifier: "showLocationChooser", sender: nil)
    }
    
}

//MARK: - LocationChooserDelegate

extension TaxiMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        addressesChooserView.toAddress = newLocation
    }
    
    
}
