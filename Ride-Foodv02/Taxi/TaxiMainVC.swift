import UIKit
import MapKit
import CoreLocation

class TaxiMainVC: UIViewController {

    //MARK: - API
    
    var fromAddress = String() { didSet { updateUI() }}
    var toAddress = String() { didSet { updateUI() }}
    var addresses = [Address]()
    
    let taxiMainInteractor = TaxiMainInteractor()

    //MARK: - Private properties
    
    private var safeAreaBottomHeight: CGFloat = 0.0
    private var responderTextField: UITextField?
    private var keyboardHeight: CGFloat = 0.0
    private var shouldUpdateUI = true
    private var yOffset: CGFloat = 0

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightView: UIView!
    @IBOutlet weak var addressesChooserView: UIView! { didSet {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDown(_:)))
        swipe.direction = .down
        addressesChooserView.addGestureRecognizer(swipe)
    }}

    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var fromTextField: UITextField! { didSet {
        fromTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        fromTextField.addTarget(self, action: #selector(fromTextFieldChanged), for: .editingChanged)
        fromTextField.delegate = self
        fromTextField.placeholder = Localizable.Taxi.fromAddressQuestion.localized
    }}
    @IBOutlet weak var fromAnnotationView: UIImageView!
    @IBOutlet weak var fromUnderbarLine: UIView!
    
    @IBOutlet weak var toTextField:UITextField! { didSet {
        toTextField.font = UIFont.SFUIDisplayLight(size: 17.0)
        toTextField.addTarget(self, action: #selector(toTextFieldChanged), for: .editingChanged)
        toTextField.delegate = self
        toTextField.placeholder = Localizable.Taxi.toAddressQuestion.localized
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
        nextButton.setTitle(Localizable.Taxi.next.localized, for: .normal)
    }}
    
    @IBOutlet weak var mapButton: UIButton! { didSet {
        mapButton.setTitle(Localizable.Taxi.map.localized, for: .normal)
    }}
    @IBOutlet weak var mapBigButton: UIButton!
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
   
    private let fromAddressDetailView = FromAddressDetailView.initFromNib()
    private let toAddressDetailView = ToAddressDetailView.initFromNib()

    //MARK: - Actions
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton) {
        moveDown()
        shouldUpdateUI = false
        bottomConstaint.constant -= addressesChooserViewHeightConstraint.constant
        fromAddressDetailView.isHidden = false
        transparentView.isHidden = false
        
        fromAddressDetailView.textField.becomeFirstResponder()

        fromAddressDetailView.frame = CGRect(x: view.bounds.width,
                                             y: view.bounds.height - keyboardHeight - TaxiConstant.fromAddressDetailViewHeight,
                                             width: view.bounds.width,
                                             height: TaxiConstant.fromAddressDetailViewHeight)
        fromAddressDetailView.placeLabel.text = fromAddress

        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.fromAddressDetailView.frame.origin.x = 0
        } completion: {  if $0 == .end {

        }
        }
        
        
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(moveAddressesChooserView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        

        getAdressesFromServer()
        

        
        
        fromAddressDetailView.delegate = self
        fromAddressDetailView.isHidden = true
        
        toAddressDetailView.delegate = self
        toAddressDetailView.isHidden = true
        view.addSubview(fromAddressDetailView)
        view.addSubview(toAddressDetailView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + tableViewHeightConstraint.constant
        responderTextField?.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        safeAreaBottomHeight = view.safeAreaInsets.bottom
        showMapItems(false)
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
                //self?.toAddress = $0
                self?.fromAddress = $0
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
        
        if keyboardHeight == 0 { keyboardHeight = size.height }
        if shouldUpdateUI {
            updateConstraints()
            tableViewHeightView.isHidden = false
            setBottomConstraintTo(keyboardHeight - safeAreaBottomHeight)
            showMapItems(true)
            shouldUpdateUI = false
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
    
    //MARK: - UI update
    func showMapItems(_ bool:Bool) {
        verticalLineView.isHidden = !bool && responderTextField == nil
        mapButton.isHidden = !bool && responderTextField == nil
        arrowButton.isHidden = !bool && responderTextField == nil
        transparentView.isHidden = !bool && responderTextField == nil
        mapBigButton.isUserInteractionEnabled = !(!bool && responderTextField == nil)
    }
    
    private func updateUI() {
        
        fromTextField?.text = fromAddress
        toTextField?.text = toAddress

        fromUnderbarLine?.backgroundColor = fromAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        toUnderbarLine?.backgroundColor = toAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.9843137255, green: 0.5568627451, blue: 0.3137254902, alpha: 1)

        fromAnnotationView?.image = fromAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "Annotation")
        toAnnotationView?.image = toAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "OrangeAnnotation")

        nextButton?.isUserInteractionEnabled = !fromAddress.isEmpty && !toAddress.isEmpty

        roundedView?.colorToFill = (!fromAddress.isEmpty && !toAddress.isEmpty) ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        
        gradientImageView?.isHidden = fromAddress.isEmpty || toAddress.isEmpty
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
        responderTextField = nil
        setBottomConstraintTo(0)
        showMapItems(false)
        shouldUpdateUI = true
        if !toAddress.isEmpty && !fromAddress.isEmpty {
            tableViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            tableViewHeightView.isHidden = true
            gradientImageView.isHidden = false
        } else {
            tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
            addressesChooserViewHeightConstraint.constant += yOffset
        }
        
    }
    
    
    private func updateConstraints() {
        tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + tableViewHeightConstraint.constant
        compressAddressesViewToFitHeight()
    }
    
    private func compressAddressesViewToFitHeight() {
        if view.bounds.height - keyboardHeight - addressesChooserViewHeightConstraint.constant < 0 {
            yOffset = abs(view.bounds.height - keyboardHeight - addressesChooserViewHeightConstraint.constant)
            tableViewHeightConstraint.constant -= yOffset
            addressesChooserViewHeightConstraint.constant -= yOffset
        }
        
    }
    
    // MARK: - Alexey Methods
    
    // Загрузка адресов с сервера
    private func getAdressesFromServer() {
        
        AddressesNetworkManager.shared.getTheAddresses { result in
            
            switch result {
            case .success(let adressesData):
    
                self.taxiMainInteractor.createCoreDataInstance(addressesToCopy: adressesData)
                self.saveAdressesInCoreData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Загрузка адресов из Core Data
    func saveAdressesInCoreData() {
        PersistanceManager.shared.fetchAddresses { result in
            switch result {
            case .success(let addresses):
                addresses.forEach {
                    self.addresses.append(Address(title: $0.title ?? "", fullAddress: $0.fullAddress ?? ""))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
                } 
            default:break
            }
        }
    }
}


//MARK: - LocationChooserDelegate

extension TaxiMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        //toAddress = newLocation
        fromAddress = newLocation
    }
    
    
}

//MARK: - TableView datasourse

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
        moveDown()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        responderTextField = textField
    }
  
}

//MARK: - FromAddressDetailViewDelegate

extension TaxiMainVC: FromAddressDetailViewDelegate {
    
    func fromAddressDetailConfirm() {
        
        toAddressDetailView.isHidden = false
        
        toAddressDetailView.frame = CGRect(x: view.bounds.width,
                                           y: view.bounds.height - keyboardHeight - TaxiConstant.toAddressDetailViewHeight,
                                           width: view.bounds.width,
                                           height: TaxiConstant.toAddressDetailViewHeight)
        fromAddressDetailView.textField.resignFirstResponder()
        toAddressDetailView.textField.becomeFirstResponder()
        
        toAddressDetailView.placeLabel.text = toAddress
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.toAddressDetailView.frame.origin.x = 0
            self.fromAddressDetailView.frame.origin.x = -self.view.bounds.width
        } completion: { if $0 == .end {}
        }

    }
    
    
}

//MARK: - ToAddressesDetaileViewDelegate

extension TaxiMainVC: ToAddressDetailViewDelegate {
    
    func toAddressDetailConfirm() {
        transparentView.isHidden = true
        bottomConstaint.constant = 0.0
        toAddressDetailView.textField.resignFirstResponder()
        addressesChooserView.isUserInteractionEnabled = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.toAddressDetailView.frame.origin.x = -self.view.bounds.width
        } completion: { if $0 == .end {
            self.toAddressDetailView.removeFromSuperview()
            self.fromAddressDetailView.removeFromSuperview()
            self.shouldUpdateUI = true
            self.addressesChooserView.isUserInteractionEnabled = true
        }
        }
    }
    
    
}
