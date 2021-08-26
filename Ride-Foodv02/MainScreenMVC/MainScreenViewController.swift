import UIKit
import MapKit
import CoreLocation

class MainScreenViewController: UIViewController {
    
    // MARK: - Taxi Outlets
    
    
    @IBOutlet weak var taxiBackButtonOutlet: UIButton! { didSet {
        taxiBackButtonOutlet.alpha = 0
    }}
    
    @IBOutlet weak var pathTimeView: UIView! { didSet {
        pathTimeView.alpha = 0
    }}
    
    @IBOutlet weak var timeLabel: UILabel! { didSet {
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        timeLabel.textColor = TaxiSpecifyFromToColor.white.value
    }}
    
    
    @IBOutlet weak var nextButton: UIButton! { didSet {
        nextButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        nextButton.setTitle(Localizable.Taxi.next.localized, for: .normal)
    }}
    
    @IBOutlet weak var addressesChooserView: UIView! { didSet {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(moveDown(_:)))
        swipe.direction = .down
        addressesChooserView.addGestureRecognizer(swipe)
    }}
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoCorneredView: TopRoundedView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightView: UIView! { didSet {
        tableViewHeightView.isHidden = true
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
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var mapButton: UIButton! { didSet {
        mapButton.setTitle(Localizable.Taxi.map.localized, for: .normal)
    }}
    @IBOutlet weak var mapBigButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var verticalLineView: UIView!
    
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! { didSet {
        tableViewHeightConstraint.constant = 0
    }}
    
    @IBOutlet weak var addressesChooserViewHeightConstraint: NSLayoutConstraint! { didSet{
//        let safeAreaBottomHeight = view.safeAreaInsets.bottom
//        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + safeAreaBottomHeight
    }}
    
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint! { didSet {
        bottomConstaint.constant = -300
    }}
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var wholeTransparentView: UIView!
    
    // MARK: - Outlets
    
    @IBOutlet weak var userLocationButtonOutlet: UIButton! { didSet{
        userLocationButtonOutlet.alpha = 0
    }}

    @IBOutlet weak var userLocationButtonConstraint: NSLayoutConstraint! { didSet {
        userLocationButtonConstraint.constant = addressesChooserView.frame.height + promotionView.touchableView.frame.height //5//promotionView.touchableView.frame.height + 5//foodTaxiView.frame.height// + promotionView.touchableView.frame.height + 20

    }}
    
    @IBOutlet weak var mapView: MKMapView! { didSet {
        let center = CLLocationCoordinate2D(latitude: 55.7520, longitude: 37.6175)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTouched(_:))))
        mapView.delegate = self
    }}
    
    @IBOutlet weak var transparentView: UIView! { didSet {
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenuView(_:)))
        //transparentView.addGestureRecognizer(tapGesture)
    }}
    
    @IBOutlet weak var circleView: CircleView! { didSet {
        circleView.color = .white
    }}
    
    @IBOutlet weak var menuButton: UIButton! { didSet {
        menuButton.isExclusiveTouch = true
    }}
    
    // MARK: - XIB files
    
    let menuView = MenuView.initFromNib()
    let foodTaxiView = FoodTaxiView.initFromNib()
    let promotionView = PromotionView.initFromNib()
    let promotionDetailView = PromotionDetail.initFromNib()
    let setToLocationView = SetToLocationView.initFromNib()
    let fromAddressDetailView = FromAddressDetailView.initFromNib()
    let toAddressDetailView = ToAddressDetailView.initFromNib()
    let taxiTariffView = TaxiTariffView.initFromNib()
    let scoresView = ScoresView.initFromNib()
    let scoresToolbar = ScoresToolbar.initFromNib()
    
    // MARK: - Properties

    var fromAddress = String() { didSet { updateUI() }}
    var toAddress = String() { didSet { updateUI() }}
    var addresses = [Address]()
    var currentUserCoordinate: CLLocationCoordinate2D?
    var isMainScreen = true

    let taxiMainInteractor = TaxiMainInteractor()
    
    private var bottomSafeAreaConstant: CGFloat = 0
    
    private var safeAreaBottomHeight: CGFloat = 0.0
    var responderTextField: UITextField?
    var keyboardHeight: CGFloat = 0.0
    var shouldUpdateUI = true
    private var yOffset: CGFloat = 0
    var shouldMakeOrder = false
    


    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.delegate = self
        foodTaxiView.delegate = self
        promotionView.delegate = self
        promotionDetailView.delegate = self
        view.addSubview(menuView)
        view.addSubview(foodTaxiView)
        view.addSubview(promotionView)
        view.addSubview(promotionDetailView)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomSafeAreaConstant = view.safeAreaInsets.bottom
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetToLocationView()
        menuView.layoutSubviews()
        
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight
        responderTextField?.becomeFirstResponder()
        
        MapKitManager.shared.checkLocationServices(delegate: self, view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        safeAreaBottomHeight = view.safeAreaInsets.bottom
        taxiTariffView.frame = CGRect(x: 0, y: 135, width: view.bounds.width, height: 155)
        
        if !menuView.isVisible {
            resetFrames()
        }
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    func animationUerLocationButton() {
        
        userLocationButtonConstraint.constant -= promotionView.touchableView.frame.height //foodTaxiView.frame.height - safeAreaBottomHeight
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
 
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "food",
           let destination = segue.destination as? FoodMainVC {
            transparentView.isHidden = false
            destination.modalPresentationStyle = .custom
            destination.place = foodTaxiView.placeLabel.text ?? ""
            destination.delegate = self
            destination.region = mapView.region
//        } else if segue.identifier == "taxi",
//                  let destination = segue.destination as? TaxiMainVC {
//            print("Segue Taxi")
//            destination.fromAddress = foodTaxiView.placeLabel.text ?? ""
//            MapKitManager.shared.currentUserCoordinate = mapView.annotations.first?.coordinate
        }
    }
    
    //MARK: - Taxi UI update
    
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
    
    private func setToAddressViewUpdateUI() {

        setToLocationView.underLineView.backgroundColor = toAddress.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.9843137255, green: 0.5568627451, blue: 0.3137254902, alpha: 1)
        setToLocationView.locationImageView.image = toAddress.isEmpty ? #imageLiteral(resourceName: "RawAnnotation") : #imageLiteral(resourceName: "OrangeAnnotation")
        setToLocationView.confirmButton.isUserInteractionEnabled = !toAddress.isEmpty
        setToLocationView.confirmButton.backgroundColor = !toAddress.isEmpty ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }
    
    //MARK: - Taxi constaint update
    
    private func setBottomConstraintTo(_ y:CGFloat) {
        bottomConstaint.constant = y
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: TaxiConstant.durationForAppearingAddressesChooserView, delay: 0.0, options: .curveLinear) {
            self.view.layoutIfNeeded()
        } completion: { if $0 == .end {}
        }
    }
    
    // MARK: - Taxi Methods
    
    func loadSetupsTaxi() {
        
        updateUI()
        
        let safeAreaBottomHeight = view.safeAreaInsets.bottom
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + safeAreaBottomHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveAddressesChooserView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownView(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        
        setToLocationView.delegate = self
        
        view.addSubview(fromAddressDetailView)
        view.addSubview(toAddressDetailView)
        addressesChooserView.addSubview(taxiTariffView)
        view.addSubview(scoresView)
        view.addSubview(scoresToolbar)
        
        animatedTaxiView()
    }
    
    private func animatedTaxiView() {

        UIView.animate(withDuration: 0.5) {
            self.foodTaxiView.frame.origin.y = self.view.frame.height
            self.menuButton.alpha = 0
            self.circleView.alpha = 0
            self.promotionView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.userLocationButtonConstraint.constant = 5
            self.bottomConstaint.constant = 0
 
            
            UIView.animate(withDuration: 0.5) {
                self.taxiBackButtonOutlet.alpha = 1
                self.view.layoutIfNeeded()
                print(self.userLocationButtonConstraint.constant)
            }
        }
    }
    

    func setupSetToLocationView() {
        setToLocationView.frame.size = CGSize(width: view.frame.width, height: 200)
        setToLocationView.frame.origin.y = view.frame.height
            
        setToLocationView.layer.cornerRadius = view.frame.width / 16
        setToLocationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        setToLocationView.layer.shadowColor = UIColor.black.cgColor
        setToLocationView.layer.shadowOpacity = 1
        setToLocationView.layer.shadowOffset = .zero
        setToLocationView.layer.shadowRadius = 10
        
        setToLocationView.layer.cornerRadius = 15
        setToLocationView.confirmButton.layer.cornerRadius = 15
        setToLocationView.confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        setToLocationView.confirmButton.setTitleColor(.white, for: .normal)
        setToLocationView.confirmButton.backgroundColor = .blue
        setToLocationView.confirmButton.setTitle(Localizable.Food.confirm.localized, for: .normal)
        
        setToLocationView.locationTextField.text = ""
        
        setToLocationView.locationTextField.addTarget(self, action: #selector(toLocationEnterChanged), for: .editingChanged)
        
    }
    
    // Загрузка адресов из Core Data
    func loadAdressesFromCoreData() {
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

                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                }
            default:break
            }
        }
    }
    
    //Действие при опускании окна вниз
    func moveDown() {
        
        view.endEditing(true)
        transparentView.isHidden = true
        responderTextField = nil
        setBottomConstraintTo(0)
        taxiTariffView.removeFromSuperview()
        twoCorneredView.backgroundColor = .white
        showMapItems(false)
        shouldUpdateUI = true
        tableViewHeightConstraint.constant = 0
        
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        let safeArea = window.safeAreaInsets.bottom
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + safeArea
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        tableViewHeightView.isHidden = true
    }
    
    func setFromMarket() {
        if fromAddress != "" {
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
    
    func setToMarker() {
        if toAddress != "" {
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
    
    
    // MARK: - @objc Taxi Methods
    
    @objc
    private func moveAddressesChooserView(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if keyboardHeight == 0 { keyboardHeight = size.height }
        
        if shouldUpdateUI {
            setBottomConstraintTo(keyboardHeight - safeAreaBottomHeight)
            shouldUpdateUI = false
        }
        
        if !isMainScreen {
            
            UIView.animate(withDuration: 0.3) {
                self.setToLocationView.frame.origin.y = self.view.frame.height - self.setToLocationView.frame.height - self.keyboardHeight
            }
        }
    }
    
    @objc
    private func moveDownView(_ recognizer: UITapGestureRecognizer) {
            if !isMainScreen {
                UIView.animate(withDuration: 0.3) {
                    self.setToLocationView.frame.origin.y = self.view.frame.height - self.setToLocationView.frame.height
                }
                if toAddress != "" {
                    taxiMainInteractor.getCoordinates(from: toAddress, to: mapView) { address in
                        self.toAddress = address
                    }
                }
            }
    }
    
    @objc
    private func mapViewTouched(_ recognizer: UITapGestureRecognizer) {

        if recognizer.state == .ended {
            
            SetMapMarkersManager.shared.isFromAddressMarkSelected = isMainScreen ? true : false
            
            let location = recognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            if let userLocation = MapKitManager.shared.currentUserCoordinate {
                userLocationButtonOutlet.alpha = userLocation == coordinate ? 0 : 1
            }

            SetMapMarkersManager.shared.setMarkOn(map: mapView, with: coordinate) { address in
                
                
                if self.isMainScreen {
                    self.fromAddress = address
                    self.foodTaxiView.placeLabel.text = self.fromAddress
                } else {
                    self.toAddress = address
                    self.setToLocationView.locationTextField.text = self.toAddress
                }
            }
        }
    }
    
    @objc
    private func toLocationEnterChanged() {
        toAddress = setToLocationView.locationTextField.text ?? ""
        if toAddress == "" {
            mapView.removeAnnotations(mapView.annotations)
        }
        setToAddressViewUpdateUI()
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
    
    //MARK: - Helper
    
//    @objc
//    private func closeMenuView(_ recognizer: UITapGestureRecognizer) {
//        if recognizer.state == .ended {
//            close()
//        }
//    }
    
    func resetFrames() {
        menuView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width - MainScreenConstants.menuViewXOffset, height: view.bounds.height)
        foodTaxiView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.foodTaxiViewHeight + bottomSafeAreaConstant)
        promotionView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - MainScreenConstants.foodTaxiYOffset - bottomSafeAreaConstant - MainScreenConstants.promotionViewHeight, width: view.bounds.width, height: MainScreenConstants.promotionViewHeight)
        promotionDetailView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
    }
    
    // MARK: - Actions
    
    @IBAction func next(_ sender: UIButton) {
        if shouldMakeOrder {
            if taxiTariffView.superview == nil { addressesChooserView.addSubview(taxiTariffView) }
            addressesChooserViewHeightConstraint.constant = 370
            twoCorneredView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            topConstraint.constant = 0
            roundedView.backgroundColor = .clear
            taxiTariffView.isHidden = false
            taxiTariffView.reset()
            roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
            roundedView.isUserInteractionEnabled = false
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
    
    
    @IBAction func goToMenu(_ sender: MenuButton) {
        transparentView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForAppearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.menuView.frame.origin.x = 0
                self.foodTaxiView.frame.origin.y = self.view.bounds.height + MainScreenConstants.promotionViewHeight + MainScreenConstants.foodTaxiYOffset
                self.promotionView.frame.origin.y = self.view.bounds.height
            }) {
            if $0 == .end { self.menuView.isVisible = true }
        }
    }
    
    @IBAction func goToProfile(_ sender: UIButton) {
        goToStoryboard("UserProfile")
    }
    
//    @IBAction func goToMainScreen(_ segue: UIStoryboardSegue) {}
    
    
    @IBAction func userLocationButtonAction(_ sender: Any) {
        MapKitManager.shared.locationManager.startUpdatingLocation()
        userLocationButtonOutlet.alpha = 0
    }
    
    @IBAction func taxiBackButtonAction(_ sender: UIButton) {
        
        bottomConstaint.constant = -300
        userLocationButtonConstraint.constant = addressesChooserView.frame.height + promotionView.touchableView.frame.height
        
        UIView.animate(withDuration: 0.5) {
            self.taxiBackButtonOutlet.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            UIView.animate(withDuration: 0.5) {
                self.foodTaxiView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height
                self.menuButton.alpha = 1
                self.circleView.alpha = 1
                self.promotionView.alpha = 1
                self.view.layoutIfNeeded()
                print(self.userLocationButtonConstraint.constant)
            }
        }

        SetMapMarkersManager.shared.isPathCalculeted = false
        SetMapMarkersManager.shared.isFromAddressMarkSelected = true
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        
        moveDown()
        bottomConstaint.constant = -300
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            
        } completion: { _ in

            UIView.animate(withDuration: 0.5) {
                self.view.addSubview(self.setToLocationView)
                self.setToLocationView.frame.origin.y = self.view.frame.height - self.setToLocationView.frame.height
            }

            self.isMainScreen = false
            SetMapMarkersManager.shared.isFromAddressMarkSelected = false
            for mark in self.mapView.annotations {
                if mark.title == "From" {
                    self.mapView.removeAnnotation(mark)
                }
            }

            let setPoint = self.toAddress == "" ? self.fromAddress : self.toAddress

            self.taxiMainInteractor.getCoordinates(from: setPoint, to: self.mapView) { address in
                self.toAddress = address
                self.setToLocationView.locationTextField.text = self.toAddress
                self.setToAddressViewUpdateUI()
            }
        }
    }
}
