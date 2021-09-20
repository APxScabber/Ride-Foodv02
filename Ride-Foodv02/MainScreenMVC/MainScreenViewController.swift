import UIKit
import MapKit
import CoreLocation

class MainScreenViewController: BaseViewController {
    
    // MARK: - Taxi Outlets
    
    //MARK: - Buttons
    
    @IBOutlet weak var taxiBackButtonOutlet: UIButton! { didSet {
        taxiBackButtonOutlet.alpha = 0
    }}
    @IBOutlet weak var nextButton: UIButton! { didSet {
        nextButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        nextButton.setTitle(Localizable.Taxi.next.localized, for: .normal)
    }}
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton! { didSet {
        mapButton.setTitle(Localizable.Taxi.map.localized, for: .normal)
    }}
    
    @IBOutlet weak var mapBigButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var menuButton: BackButton! { didSet {
        menuButton.isExclusiveTouch = true
    }}
    
    @IBOutlet weak var userLocationButtonOutlet: UIButton! { didSet{
        userLocationButtonOutlet.alpha = 0
    }}
    
    //MARK: - Views
    
    @IBOutlet weak var pathTimeView: UIView! { didSet {
        pathTimeView.alpha = 0
    }}
    
    @IBOutlet weak var pathTimeBG: UIImageView!
    
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
    
    @IBOutlet weak var fromAnnotationView: UIImageView!
    @IBOutlet weak var fromUnderbarLine: UIView!
    
    @IBOutlet weak var toAnnotationView: UIImageView!
    @IBOutlet weak var toUnderbarLine: UIView!
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    
    @IBOutlet weak var verticalLineView: UIView!


    @IBOutlet weak var mapView: MKMapView! { didSet {
        let center = CLLocationCoordinate2D(latitude: 55.7520, longitude: 37.6175)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapViewTouched(_:))))
        mapView.delegate = self
    }}
    
    @IBOutlet weak var transparentView: UIView! { didSet {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenuView(_:)))
        transparentView.addGestureRecognizer(tapGesture)
    }}
    @IBOutlet weak var wholeTransparentView: UIView!

    @IBOutlet weak var circleView: CircleView! { didSet {
        circleView.color = .white
    }}
    
    //MARK: - Constraints
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! { didSet {
        tableViewHeightConstraint.constant = 0
    }}
    
    @IBOutlet weak var addressesChooserViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint! { didSet {
        bottomConstaint.constant = -300
    }}
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    @IBOutlet weak var userLocationButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var roundedViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundedViewBottomConstraint: NSLayoutConstraint! { didSet {
        roundedViewBottomConstraint.priority = .defaultLow
    }}
    
    //MARK: - TextField
    
    @IBOutlet weak var fromTextField: UITextField! { didSet {
        fromTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        fromTextField.addTarget(self, action: #selector(fromTextFieldChanged), for: .editingChanged)
        fromTextField.addTarget(self, action: #selector(fromTextFieldEnd), for: .editingDidEnd)
        fromTextField.delegate = self
        fromTextField.placeholder = Localizable.Taxi.fromAddressQuestion.localized
    }}
    
    @IBOutlet weak var toTextField:UITextField! { didSet {
        toTextField.font = UIFont.SFUIDisplayLight(size: 17.0)
        toTextField.addTarget(self, action: #selector(toTextFieldChanged), for: .editingChanged)
        toTextField.addTarget(self, action: #selector(toTextFieldEnd), for: .editingDidEnd)
        toTextField.delegate = self
        toTextField.placeholder = Localizable.Taxi.toAddressQuestion.localized
    }}
    
    //MARK: - Labels
    
    @IBOutlet weak var timeLabel: UILabel! { didSet {
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        timeLabel.textColor = TaxiSpecifyFromToColor.white.value
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
    let promocodeScoresView = PromocodeScoresView.initFromNib()
    let scoresView = ScoresView.initFromNib()
    let scoresToolbar = ScoresToolbar.initFromNib()
    let promocodeToolbar = PromocodeToolbar.initFromNib()
    let promocodeActivationView = PromocodeActivation.initFromNib()
    
    let taxiOrderInfoView = TaxiOrderInfo.initFromNib()
    
    // MARK: - Properties

    var fromAddress = String() { didSet { updateUI() }}
    var toAddress = String() { didSet { updateUI() }}
    var addresses = [Address]()
    var currentUserCoordinate: CLLocationCoordinate2D?
    var isMainScreen = true
    
    let mainScreenInteractor = MainScreenInteractor()
    let separationText = SeparetionText()
    
    private var bottomSafeAreaConstant: CGFloat = 0
    
    var safeAreaBottomHeight: CGFloat = 0.0
    var responderTextField: UITextField?
    var keyboardHeight: CGFloat = 0.0
    var shouldUpdateUI = true
    private var yOffset: CGFloat = 0
    var shouldMakeOrder = false
    
    var taxiTariffSelected = 0
    var timeRemainig: Int?
    
    var isTaxiOrdered = false
    var isFoodOrdered = false
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTaxiView.layer.shadowColor = UIColor.black.cgColor
        foodTaxiView.layer.shadowOpacity = 0.3
        foodTaxiView.layer.shadowOffset = .zero
        foodTaxiView.layer.shadowRadius = 20
        
        menuView.delegate = self
        foodTaxiView.delegate = self
        promotionView.delegate = self
        promotionDetailView.delegate = self
        promocodeToolbar.delegate = self
        promocodeActivationView.delegate = self
        PromocodeActivator.delegate = self
        promocodeScoresView.delegate = self
        promocodeToolbar.isHidden = true
        promocodeActivationView.isHidden = true
        setupTaxiOrderInfoView()
        view.addSubview(menuView)
        view.addSubview(foodTaxiView)
        view.addSubview(promotionView)
        view.addSubview(promotionDetailView)
        view.addSubview(promocodeToolbar)
        view.addSubview(promocodeActivationView)
        
        pathTimeBG.image = #imageLiteral(resourceName: "TaxiTime")
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomSafeAreaConstant = view.safeAreaInsets.bottom

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetToLocationView()
        menuView.layoutSubviews()
        
        responderTextField?.becomeFirstResponder()
        
        MapKitManager.shared.checkLocationServices(delegate: self, view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        safeAreaBottomHeight = view.safeAreaInsets.bottom
                
        if !menuView.isVisible {
            resetFrames()
        }
        userLocationButtonBottomConstraint.constant = foodTaxiView.bounds.height + promotionView.bounds.height + 20.0 - safeAreaBottomHeight

    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    func animationUserLocationButton() {
        
        userLocationButtonBottomConstraint.constant = foodTaxiView.bounds.height + 10.0 - safeAreaBottomHeight
        
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
        
        if !isTaxiOrdered {
            
            updateUI()
        
            addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + bottomSafeAreaConstant
            
            NotificationCenter.default.addObserver(self, selector: #selector(moveAddressesChooserView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(moveDownView(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            mainScreenInteractor.getAdressesFromServer(view: self)
            
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
    }
    
    private func animatedTaxiView() {

        userLocationButtonBottomConstraint.constant = 10
        
        UIView.animate(withDuration: 0.5) {
            self.foodTaxiView.frame.origin.y = self.view.frame.height
            self.menuButton.alpha = 0
            self.circleView.alpha = 0
            self.promotionView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.bottomConstaint.constant = 0
            self.userLocationButtonBottomConstraint.constant = self.addressesChooserViewHeightConstraint.constant - self.safeAreaBottomHeight
            UIView.animate(withDuration: 0.5) {
                self.taxiBackButtonOutlet.alpha = 1
                self.view.layoutIfNeeded()
                print(self.userLocationButtonBottomConstraint.constant)
            }
        }
    }
    

    func setupSetToLocationView() {
        mainScreenInteractor.setupLocation(view: setToLocationView, for: view)
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
                    
                    self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
                    self.addressesChooserViewHeightConstraint.constant += self.tableViewHeightConstraint.constant
                    self.compressAddressesViewToFitHeight()
                    self.userLocationButtonBottomConstraint.constant = self.addressesChooserViewHeightConstraint.constant + self.keyboardHeight - self.safeAreaBottomHeight
                    self.tableView.reloadData()

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
        addresses.removeAll()
        transparentView.isHidden = true
        responderTextField = nil
        setBottomConstraintTo(0)
        taxiTariffView.removeFromSuperview()
        roundedViewTopConstraint.priority = .required
        roundedViewBottomConstraint.priority = .defaultLow
        twoCorneredView.backgroundColor = .white
        showMapItems(false)
        shouldUpdateUI = true
        tableViewHeightConstraint.constant = 0
        addressesChooserViewHeightConstraint.constant = TaxiConstant.addressesChooserViewHeight + safeAreaBottomHeight
        userLocationButtonBottomConstraint.constant = addressesChooserViewHeightConstraint.constant - safeAreaBottomHeight
        if shouldMakeOrder {
            roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
            roundedView.isUserInteractionEnabled = true
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        nextButton.setTitle(Localizable.Taxi.next.localized, for: .normal)
        tableViewHeightView.isHidden = true
    }
    
    func setFromMarket() {
        if fromAddress != "" {

            SetMapMarkersManager.shared.isFromAddressMarkSelected = true
            mainScreenInteractor.getCoordinates(from: fromAddress, to: mapView) { respounceAddress in
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
            mainScreenInteractor.getCoordinates(from: toAddress, to: mapView) { respounceAddress in
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
    
    func setToAndFromMarkers() {
        if fromAddress != "" {
            SetMapMarkersManager.shared.isFromAddressMarkSelected = true
            mainScreenInteractor.getCoordinates(from: fromAddress, to: mapView) { respounceAddress in
                self.fromAddress = respounceAddress
                self.setToMarker()
                
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
    
    private func compressAddressesViewToFitHeight() {
        if view.bounds.height - keyboardHeight - addressesChooserViewHeightConstraint.constant < 0 {
            yOffset = abs(view.bounds.height - keyboardHeight - addressesChooserViewHeightConstraint.constant)
            tableViewHeightConstraint.constant -= yOffset
            addressesChooserViewHeightConstraint.constant -= yOffset
        }
        
    }
    
    private func setupTaxiOrderInfoView() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(taxiInfoSwipeUp(_:)))
        swipeUp.direction = .up
        taxiOrderInfoView.addGestureRecognizer(swipeUp)
        
        mainScreenInteractor.setup(view: taxiOrderInfoView, for: view)
    }
    
    func returnToMainView() {
        
        bottomConstaint.constant = -600
        
        UIView.animate(withDuration: 0.5) {
            
            self.taxiBackButtonOutlet.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            UIView.animate(withDuration: 0.5) {
                
                self.foodTaxiView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height
                self.menuButton.alpha = 1
                self.circleView.alpha = 1
                
                if self.isTaxiOrdered {
                    
                    self.pathTimeBG.image = #imageLiteral(resourceName: "activeOrder")
                    self.timeLabel.text = "1 активный заказ"
                    self.pathTimeView.alpha = 1
                    self.foodTaxiView.taxiImageView.image = #imageLiteral(resourceName: "taxiButtonDisable")
                } else {
                    
                    self.pathTimeView.alpha = 0
                }
                
                self.userLocationButtonOutlet.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func pressTaxiOrderButton() {
        
        returnToMainView()
    
        foodTaxiView.placeAnnotationView.alpha = 0
        foodTaxiView.placeLabel.text = ""
        
        taxiOrderInfoView.fromAddressTextField.text = fromAddress
        taxiOrderInfoView.toAddressTextField.text = toAddress
        if let tariffImage = mainScreenInteractor.getTaxiTariffImage(index: taxiTariffSelected) {
            taxiOrderInfoView.taxiTypeImageView.image = tariffImage
        }
        
        let time = String(timeRemainig!)
        let fianlText = separationText.separation(input: Localizable.Taxi.remainingTime.localized, insert: time)
        //let text = "Оставшееся время в пути ≈\(timeRemainig ?? 0) мин"
        let textCount = fianlText.count
        let typeAttributeText: [NSAttributedString.Key : Any] = [.foregroundColor : PaymentWaysColors.yellowColor.value]
        let textAttribute = createTextAttribute(inputText: fianlText, type: typeAttributeText,
                                                   locRus: 24, lenRus: textCount - 24,
                                                   locEng: 19, lenEng: textCount - 19)
        

        taxiOrderInfoView.taxiInfoTimeTextView.attributedText = textAttribute
        taxiOrderInfoView.taxiInfoTimeTextView.font = UIFont.SFUIDisplayRegular(size: 17.0)
        taxiOrderInfoView.taxiInfoTimeTextView.textAlignment = .center
        
        UIView.animate(withDuration: 1) {
            self.taxiOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 35
        }

        taxiTariffView.scoresEntered = 0
        promocodeScoresView.reset()
        
        promotionView.alpha = 0
    }
    
    // MARK: - @objc Taxi Methods
    
    @objc
    private func taxiInfoSwipeUp(_ recognizer: UISwipeGestureRecognizer) {
        
        if taxiOrderInfoView.frame.height == 169 {
            if recognizer.state == .ended {
                UIView.animate(withDuration: 0.5) {
                    let height:CGFloat = 169
                    let posY = self.view.frame.height - self.foodTaxiView.frame.height - height - 15
                    self.taxiOrderInfoView.frame.origin.y = posY
                } completion: { _ in
                    self.taxiOrderInfoView.gestureRecognizers?.removeAll()
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.taxiOrderedInfoTap))
                    self.taxiOrderInfoView.addGestureRecognizer(tap)
                    
                    let swipeDowm = UISwipeGestureRecognizer(target: self, action: #selector(self.taxiInfoSwipeDown(_:)))
                    swipeDowm.direction = .down
                    self.taxiOrderInfoView.addGestureRecognizer(swipeDowm)
                }
            }
        }
    }
    
    @objc
    private func taxiInfoSwipeDown(_ recognizer: UISwipeGestureRecognizer) {
        if taxiOrderInfoView.frame.height == 169 {
            if recognizer.state == .ended {
                UIView.animate(withDuration: 0.5) {
                    let posY = self.view.frame.height - self.foodTaxiView.frame.height - 30
                    self.taxiOrderInfoView.frame.origin.y = posY
                } completion: { _ in
                    self.taxiOrderInfoView.gestureRecognizers?.removeAll()
                    
                    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.taxiInfoSwipeUp(_:)))
                    swipeUp.direction = .up
                    self.taxiOrderInfoView.addGestureRecognizer(swipeUp)
                }
            }
        }
    }
    
    @objc
    private func taxiOrderedInfoTap() {
        
        if taxiOrderInfoView.frame.height == 169 {
            
            UIView.animate(withDuration: 1) {
                
                let height:CGFloat = 434
                
                self.foodTaxiView.frame.origin.y = self.view.frame.height
                self.taxiOrderInfoView.frame.size.height = height
                
                let posY = self.view.frame.height - height
                self.taxiOrderInfoView.frame.origin.y = posY
                
                self.taxiOrderInfoView.swipeLineImageView.alpha = 0
                
                self.mainScreenInteractor.animationTaxiOrderInfoLowPart(for: self.taxiOrderInfoView)
                
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 1) {
                
                let height:CGFloat = 169
                
                self.foodTaxiView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height
                self.taxiOrderInfoView.frame.size.height = height
                self.taxiOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - height - 15
                
                self.taxiOrderInfoView.swipeLineImageView.alpha = 1
                
                self.mainScreenInteractor.animationTaxiOrderInfoLowPart(for: self.taxiOrderInfoView)

                self.view.layoutIfNeeded()
            }
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
                    mainScreenInteractor.getCoordinates(from: toAddress, to: mapView) { address in
                        self.toAddress = address
                    }
                }
            }
    }
    
    @objc
    private func mapViewTouched(_ recognizer: UITapGestureRecognizer) {
        
        if !isTaxiOrdered {
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
    }
    
    //смена маркера установки позиции ОТКУДА ехать, на маркер КУДА ехать
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
        if promotionView.superview != nil {
            promotionView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - MainScreenConstants.foodTaxiYOffset - bottomSafeAreaConstant - MainScreenConstants.promotionViewHeight, width: view.bounds.width, height: MainScreenConstants.promotionViewHeight)
        }
        promotionDetailView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
    }
    
    // MARK: - Actions
    
    @IBAction func next(_ sender: UIButton) {
        
        if isTaxiOrdered {
            
            pressTaxiOrderButton()
        }
        
        if shouldMakeOrder {
            addressesChooserViewHeightConstraint.constant = 370 + safeAreaBottomHeight
            if taxiTariffView.superview == nil { addressesChooserView.addSubview(taxiTariffView) }
            if promocodeScoresView.superview == nil { addressesChooserView.addSubview(promocodeScoresView)}
            taxiTariffView.frame = CGRect(x: 0, y: 135, width: view.bounds.width, height: 100)
            promocodeScoresView.frame = CGRect(x: 0, y: 235, width: view.bounds.width, height: 50)
            nextButton.setTitle(Localizable.Taxi.order.localized, for: .normal)
            userLocationButtonBottomConstraint.constant = addressesChooserViewHeightConstraint.constant - safeAreaBottomHeight
            roundedView.backgroundColor = .clear
            roundedViewTopConstraint.priority = .defaultLow
            roundedViewBottomConstraint.priority = .required
            taxiTariffView.isHidden = false
            taxiTariffView.reset()
            roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
            roundedView.isUserInteractionEnabled = false
            transparentView.isHidden = true
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.view.layoutIfNeeded()
            }
            promocodeScoresView.frame.size.height = 50.0
            isTaxiOrdered = true

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
            userLocationButtonBottomConstraint.constant = fromAddressDetailView.bounds.height + keyboardHeight - safeAreaBottomHeight
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.fromAddressDetailView.frame.origin.x = 0
            }
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            userLocationButtonOutlet.alpha = 0
        }
         
    }
    
    
    @IBAction func goToMenu(_ sender: MenuButton) {
        transparentView.isHidden = false
        profileButton.isUserInteractionEnabled = false
        userLocationButtonOutlet.isUserInteractionEnabled = false
        circleView.isHidden = true
        userLocationButtonOutlet.alpha = 0
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
    
    @objc
    private func closeMenuView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            close()
        }
    }
    
    @IBAction func goToProfile(_ sender: UIButton) {
        goToStoryboard("UserProfile")
    }
    
//    @IBAction func goToMainScreen(_ segue: UIStoryboardSegue) {}
    
    
    @IBAction func userLocationButtonAction(_ sender: Any) {
        MapKitManager.shared.locationManager.startUpdatingLocation()
        UIView.animate(withDuration: 0.5) {
            self.userLocationButtonOutlet.alpha = 0
        }
    }
    
    @IBAction func taxiBackButtonAction(_ sender: UIButton) {
        promotionView.alpha = 0
        
        returnToMainView()

        fromTextField.isUserInteractionEnabled = true
        toTextField.isUserInteractionEnabled = true
        shouldMakeOrder = false
        addresses.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        SetMapMarkersManager.shared.isPathCalculeted = false
        isTaxiOrdered = false
        SetMapMarkersManager.shared.isFromAddressMarkSelected = true
        MapKitManager.shared.locationManager.startUpdatingLocation()
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

            self.mainScreenInteractor.getCoordinates(from: setPoint, to: self.mapView) { address in
                self.toAddress = address
                self.setToLocationView.locationTextField.text = self.toAddress
                self.setToAddressViewUpdateUI()
            }
        }
    }
}
