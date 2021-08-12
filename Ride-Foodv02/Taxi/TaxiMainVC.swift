import UIKit
import MapKit
import CoreLocation

class TaxiMainVC: UIViewController {

    //MARK: - API
    
    var fromAddress = String() { didSet { updateUI() }}
    var toAddress = String() { didSet { updateUI() }}
    var addresses = [Address]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressesChooserView: UIView! { didSet {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDown(_:)))
        swipe.direction = .down
        addressesChooserView.addGestureRecognizer(swipe)
    }}

    
    @IBOutlet weak var fromTextField: UITextField! { didSet {
        fromTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        fromTextField.addTarget(self, action: #selector(fromTextFieldChanged), for: .editingChanged)
        fromTextField.delegate = self
    }}
    @IBOutlet weak var fromAnnotationView: UIImageView!
    @IBOutlet weak var fromUnderbarLine: UIView!
    
    @IBOutlet weak var toTextField:UITextField! { didSet {
        toTextField.font = UIFont.SFUIDisplayLight(size: 17.0)
        toTextField.addTarget(self, action: #selector(toTextFieldChanged), for: .editingChanged)
        toTextField.delegate = self
    }}
    
    @IBOutlet weak var toAnnotationView: UIImageView!
    @IBOutlet weak var toUnderbarLine: UIView!
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoCorneredView: TopRoundedView!
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var nextButton: UIButton! { didSet {
        nextButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var verticalLineView: UIView!
    @IBOutlet weak var transparentView: UIView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressesChooserViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView! { didSet {
        let center = CLLocationCoordinate2D(latitude: 55.7520, longitude: 37.6175)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTouched(_:))))
        mapView.delegate = self
    }}
   
    
    //MARK: - Actions
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(moveAddressesChooserView(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        PersistanceManager.shared.fetchAddresses { result in
            switch result {
            case .success(let addresses):
                addresses.forEach {
                    self.addresses.append(Address(title: $0.title ?? "", fullAddress: $0.fullAddress ?? ""))
                }
                self.tableView.reloadData()
                self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
            default:break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMapItems(false)
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + tableViewHeightConstraint.constant
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Map gesture
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
                self?.toAddress = $0
            }
        }
    }
    
    //MARK: - Constaint update
    
    private func setBottomConstraintTo(_ y:CGFloat) {
        bottomConstaint.constant = y
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: TaxiConstant.durationForAppearingAddressesChooserView, delay: 0.0, options: .curveLinear) {
            self.view.layoutIfNeeded()
        } completion: { if $0 == .end {}
        }

    }
    @objc
    private func moveAddressesChooserView(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if view.bounds.height - size.height - addressesChooserViewHeightConstraint.constant < 0 {
            tableViewHeightConstraint.constant -= abs(view.bounds.height - size.height - addressesChooserViewHeightConstraint.constant)
            addressesChooserViewHeightConstraint.constant -= abs(tableViewHeightConstraint.constant)
        }
        setBottomConstraintTo(size.height)
        showMapItems(true)
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationChooser",
           let destination = segue.destination as? LocationChooserViewController {
            destination.delegate = self
            destination.region = mapView.region
        }
    }
    
    //MARK: - UI update
    func showMapItems(_ bool:Bool) {
        verticalLineView.isHidden = !bool
        mapButton.isHidden = !bool
        arrowButton.isHidden = !bool
        transparentView.isHidden = !bool
    }
    
    private func updateUI() {
        
        fromTextField?.text = fromAddress
        toTextField?.text = toAddress

        fromUnderbarLine?.backgroundColor = fromAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        toUnderbarLine?.backgroundColor = toAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)

        fromAnnotationView?.image = fromAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "Annotation")
        toAnnotationView?.image = toAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "Annotation")

        nextButton?.isUserInteractionEnabled = !fromAddress.isEmpty && !toAddress.isEmpty

        roundedView?.colorToFill = (!fromAddress.isEmpty && !toAddress.isEmpty) ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        
    }
    
    @objc
    private func toTextFieldChanged() {
        toAddress = toTextField.text ?? ""
    }
    
    @objc
    private func fromTextFieldChanged() {
        fromAddress = fromTextField.text ?? ""
    }
    
    @objc
    private func moveDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            moveDown()
        }
    }
    
    private func moveDown() {
        toTextField.resignFirstResponder()
        fromTextField.resignFirstResponder()
        setBottomConstraintTo(0)
        showMapItems(false)
        tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + tableViewHeightConstraint.constant
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

//MARK: - LocationChooserDelegate

extension TaxiMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        toAddress = newLocation
    }
    
    
}

extension TaxiMainVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodMainCell", for: indexPath)
        if let foodMainCell = cell as? FoodMainTableViewCell {
            foodMainCell.placeLabel.text = addresses[indexPath.row].title
            foodMainCell.addressLabel.text = addresses[indexPath.row].fullAddress
            return foodMainCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toAddress = addresses[indexPath.row].fullAddress
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FoodConstants.tableViewRowHeight
    }
}

//MARK: - UItextfield delegate

extension TaxiMainVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveDown()
        return true
    }
    
  
}