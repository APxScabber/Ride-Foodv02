import UIKit
import MapKit
import CoreLocation

class TaxiMainVC: UIViewController {

    //MARK: - API
    
    var fromAddress = String() { didSet { updateUI() }}
    var toAddress = String() { didSet { updateUI() }}
    var addresses = [Address]()
    var currentUserCoordinate: CLLocationCoordinate2D?

    let taxiMainInteractor = TaxiMainInteractor()
    
    //MARK: - Private properties
    
    private var safeAreaBottomHeight: CGFloat = 0.0
    private var responderTextField: UITextField?
    private var keyboardHeight: CGFloat = 0.0
    private var shouldUpdateUI = true
    private var yOffset: CGFloat = 0
    private var shouldMakeOrder = false
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var pathTimeView: UIView! { didSet {
        pathTimeView.alpha = 0
    }}
    @IBOutlet weak var timeLabel: UILabel! { didSet {
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        timeLabel.textColor = TaxiSpecifyFromToColor.white.value
    }}
    
    @IBOutlet weak var userLocationButtonOutlet: UIButton! { didSet {
        userLocationButtonOutlet.alpha = 0
    }}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightView: UIView! { didSet {
        tableViewHeightView.isHidden = true
    }}
    @IBOutlet weak var addressesChooserView: UIView! { didSet {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDown(_:)))
        swipe.direction = .down
        addressesChooserView.addGestureRecognizer(swipe)
    }}

    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var fromTextField: UITextField! { didSet {
        fromTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        fromTextField.addTarget(self, action: #selector(fromTextFieldChanged), for: .editingChanged)
        fromTextField.addTarget(self, action: #selector(fromTextFieldEnd), for: .editingDidEnd)
        fromTextField.delegate = self
        fromTextField.placeholder = Localizable.Taxi.fromAddressQuestion.localized
    }}
    @IBOutlet weak var fromAnnotationView: UIImageView!
    @IBOutlet weak var fromUnderbarLine: UIView!
    
    @IBOutlet weak var toTextField:UITextField! { didSet {
        toTextField.font = UIFont.SFUIDisplayLight(size: 17.0)
        toTextField.addTarget(self, action: #selector(toTextFieldChanged), for: .editingChanged)
        toTextField.addTarget(self, action: #selector(toTextFieldEnd), for: .editingDidEnd)
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
    @IBOutlet weak var wholeTransparentView: UIView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! { didSet {
        tableViewHeightConstraint.constant = 0
    }}
    @IBOutlet weak var addressesChooserViewHeightConstraint: NSLayoutConstraint! { didSet{
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight
    }}
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView! { didSet {
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTouched(_:))))
        mapView.delegate = self
    }}
   
    private let fromAddressDetailView = FromAddressDetailView.initFromNib()
    private let toAddressDetailView = ToAddressDetailView.initFromNib()
    private let taxiTariffView = TaxiTariffView.initFromNib()
    private let scoresView = ScoresView.initFromNib()
    private let scoresToolbar = ScoresToolbar.initFromNib()
    
    //MARK: - Actions
    @IBAction func close(_ sender: UIButton) {
        SetMapMarkersManager.shared.isPathCalculeted = false
        SetMapMarkersManager.shared.isFromAddressMarkSelected = true
        dismiss(animated: true)
    }
    
    @IBAction func next(_ sender: UIButton) {
        if shouldMakeOrder {
            if taxiTariffView.superview == nil { addressesChooserView.addSubview(taxiTariffView) }
            addressesChooserViewHeightConstraint.constant = 370
            twoCorneredView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            topConstraint.constant = 0
            roundedView.backgroundColor = .clear
            taxiTariffView.isHidden = false
            taxiTariffView.reset()
            transparentView.isHidden = false
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.view.layoutIfNeeded()
            }

        } else {
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
            }
        }
         
    }
    
    @IBAction func userLocationButtonAction(_ sender: Any) {
        MapKitManager.shared.locationManager.startUpdatingLocation()
        userLocationButtonOutlet.alpha = 0
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(addressesChooserViewHeightConstraint.constant)
        
        
        MapKitManager.shared.checkLocationServices(delegate: self, view: self)
        
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveAddressesChooserView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        taxiMainInteractor.getAdressesFromServer(view: self)
        
        SetMapMarkersManager.shared.delegate = self
        
        fromAddressDetailView.delegate = self
        fromAddressDetailView.isHidden = true
        
        toAddressDetailView.delegate = self
        toAddressDetailView.isHidden = true
        
        taxiTariffView.isHidden = true
        taxiTariffView.delegate = self
        
        scoresView.isHidden = true
        scoresView.delegate = self
        
        scoresToolbar.isHidden = true
        scoresToolbar.delegate = self
        
        view.addSubview(fromAddressDetailView)
        view.addSubview(toAddressDetailView)
        addressesChooserView.addSubview(taxiTariffView)
        view.addSubview(scoresView)
        view.addSubview(scoresToolbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight
        responderTextField?.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        safeAreaBottomHeight = view.safeAreaInsets.bottom
        taxiTariffView.frame = CGRect(x: 0, y: 135, width: view.bounds.width, height: 155)
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Map gesture
    @objc
    private func mapViewTouched(_ recognizer: UITapGestureRecognizer) {

        if recognizer.state == .ended {
            
            
            SetMapMarkersManager.shared.isFromAddressMarkSelected = true
            
            let location = recognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            if let userLocation = MapKitManager.shared.currentUserCoordinate {
                userLocationButtonOutlet.alpha = userLocation == coordinate ? 0 : 1
            }

            SetMapMarkersManager.shared.setMarkOn(map: mapView, with: coordinate) { address in
                self.fromAddress = address
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
            setBottomConstraintTo(keyboardHeight - safeAreaBottomHeight)
            shouldUpdateUI = false
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationChooser",
           let destination = segue.destination as? LocationChooserViewController {
            destination.delegate = self
            destination.region = mapView.region
            let fromPoint = fromTextField.text
            let toPoint = toTextField.text
            destination.location = fromPoint != "" && toPoint != "" ? toAddress : fromAddress
        }
    }
    
    //MARK: - UI update
    func showMapItems(_ bool:Bool) {
        verticalLineView.isHidden = !bool && responderTextField == nil
        mapButton.isHidden = !bool && responderTextField == nil
        arrowButton.isHidden = !bool && responderTextField == nil
        
        if !SetMapMarkersManager.shared.isPathCalculeted {
            transparentView.isHidden = !bool && responderTextField == nil
        }
        
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
    }
    
    @objc
    private func toTextFieldChanged() {
        toAddress = toTextField.text ?? ""
    }
    
    @objc
    private func toTextFieldEnd() {
        setToMarker()
    }
    
    @objc
    private func fromTextFieldChanged() {
        fromAddress = fromTextField.text ?? ""
    }
    
    @objc
    private func fromTextFieldEnd() {
        setFromMarket()
    }
    
    @objc
    private func moveDown(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            moveDown()
        }
    }
    
    //Действие при опускании окна вниз
    private func moveDown() {
        
        view.endEditing(true)
        transparentView.isHidden = true
        responderTextField = nil
        setBottomConstraintTo(0)
        taxiTariffView.removeFromSuperview()
        twoCorneredView.backgroundColor = .white
        showMapItems(false)
        shouldUpdateUI = true
        tableViewHeightConstraint.constant = 0
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        tableViewHeightView.isHidden = true
    }
    
    private func setFromMarket() {
        if fromTextField.text != "" {
            SetMapMarkersManager.shared.isFromAddressMarkSelected = true
            taxiMainInteractor.getCoordinates(from: fromAddress, to: mapView) { respounceAddress in
                self.fromAddress = respounceAddress
            }
        } else {
            fromTextField.text = fromAddress
            _ = self.mapView.annotations.compactMap { mark in
                if mark.title == "From" {
                    self.mapView.removeAnnotation(mark)
                }
            }
            
        }
    }
    
    private func setToMarker() {
        if toTextField.text != "" {
            SetMapMarkersManager.shared.isFromAddressMarkSelected = false
            taxiMainInteractor.getCoordinates(from: toAddress, to: mapView) { respounceAddress in
                self.toAddress = respounceAddress
            }
        } else {
            toAddress = ""
            _ = self.mapView.annotations.compactMap { mark in
                if mark.title == "To" {
                    self.mapView.removeAnnotation(mark)
                }
            }
        }
    }
    
    private func compressAddressesViewToFitHeight() {
        if view.bounds.height - keyboardHeight - addressesChooserViewHeightConstraint.constant < 0 {
            yOffset = abs(view.bounds.height - keyboardHeight - addressesChooserViewHeightConstraint.constant)
            tableViewHeightConstraint.constant -= yOffset
            addressesChooserViewHeightConstraint.constant -= yOffset
        }
        
    }
    
    // MARK: - Methods
    
    // Загрузка адресов из Core Data
    private func loadAdressesFromCoreData() {
        PersistanceManager.shared.fetchAddresses { result in
            switch result {
            case .success(let addresses):
                addresses.forEach {
                    self.addresses.append(Address(title: $0.title ?? "", fullAddress: $0.fullAddress ?? ""))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
                    self.addressesChooserViewHeightConstraint.constant += self.tableViewHeightConstraint.constant
                    print("UP \(self.addressesChooserViewHeightConstraint.constant)")
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            default:break
            }
        }
    }
}

//MARK: - LocationChooserDelegate

extension TaxiMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        toAddress = newLocation
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
        
        showMapItems(true)
        
        switch textField.tag {
        case 0:
            tableViewHeightView.isHidden = true
            addressesChooserViewHeightConstraint.constant -= tableViewHeightConstraint.constant
            print("Down \(addressesChooserViewHeightConstraint.constant)")
            tableViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        case 1:
            tableViewHeightView.isHidden = false
            addresses.removeAll()
            loadAdressesFromCoreData()
            
        default:
            break
        } 
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
            self.shouldMakeOrder = true
        }
        }
        CalculatingPathManager.shared.calculatingPath(for: mapView) { pathTime in
            self.pathTime(minutes: pathTime)
        }
        
        SetMapMarkersManager.shared.isPathCalculeted = true
        gradientImageView?.isHidden = fromAddress.isEmpty || toAddress.isEmpty
        showMapItems(true)
    }
}

//MARK: - TaxiTariffViewDelegate

extension TaxiMainVC: TaxiTariffViewDelegate {
    
    
    func useScores() {
        if !taxiTariffView.usedScores && taxiTariffView.selectedIndex != nil {
            wholeTransparentView.isHidden = false
            scoresView.isHidden = false
            scoresView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 157)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.scoresView.frame.origin.y = self.view.bounds.height - 157
            }
        }

    }
    
    func usePromocode() {
        
    }
    
}

extension TaxiMainVC: ScoresViewDelegate {
    
    func showScoresToolbar() {
        scoresToolbar.isHidden = false
        shouldUpdateUI = false
        scoresToolbar.scores = scoresView.scores
        scoresToolbar.textField.becomeFirstResponder()
        scoresToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 128)
        shouldUpdateUI = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresToolbar.frame.origin.y = self.view.bounds.height - self.keyboardHeight - 128
        }

    }
    
    func closeScoresView() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresView.frame.origin.y = self.view.bounds.height
        }completion: { if $0 == .end {
            self.wholeTransparentView.isHidden = true
            self.scoresView.isHidden = true
        }}
    }
    
    func spendAllScores() {
        enter(scores: scoresView.scores)
    }
}

//MARK: - ScoresToolbarDelegate

extension TaxiMainVC: ScoresToolbarDelegate {
    
    func closeScoresToolbar() {
        
        scoresToolbar.textField.resignFirstResponder()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.scoresToolbar.frame.origin.y = self.view.bounds.height
        } completion: {  if $0 == .end {
            self.scoresToolbar.isHidden = true
        }
        }
    }
    
    func enter(scores: Int) {
        closeScoresToolbar()
        closeScoresView()
        taxiTariffView.updateUIWith(scores: scores)
    }
}
