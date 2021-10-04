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
    }}
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var mapButton: UIButton!
    
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
    }}
    
    @IBOutlet weak var toTextField:UITextField! { didSet {
        toTextField.font = UIFont.SFUIDisplayLight(size: 17.0)
        toTextField.addTarget(self, action: #selector(toTextFieldChanged), for: .editingChanged)
        toTextField.addTarget(self, action: #selector(toTextFieldEnd), for: .editingDidEnd)
        toTextField.delegate = self
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
    let foodOrderInfoView = FoodOrderInfo.initFromNib()
    let orderCompleteView = OrderCompleteView.initFromNib()
    let deliveryMainView = DeliveryMainView.initFromNib()
    
    // MARK: - Search driver screen content
    
    var containerView = UIView()
    
    // MARK: - Properties

    var fromAddress = String() { didSet { updateUI() }}
    var toAddress = String() { didSet { updateUI() }}
    var addresses = [Address]()
    var currentUserCoordinate: CLLocationCoordinate2D?
    var isMainScreen = true
    
    let mainScreenInteractor = MainScreenInteractor()
    let separationText = SeparetionText()
    
    var bottomSafeAreaConstant: CGFloat = 0
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var safeAreaBottomHeight: CGFloat = 0.0
    var responderTextField: UITextField?
    var keyboardHeight: CGFloat = 0.0
    var shouldUpdateUI = true
    private var yOffset: CGFloat = 0
    var shouldMakeOrder = false
    
    var taxiTariffSelected = 0
    var timeRemainig: String?
    
    var isTaxiOrdered = false
    var isFoodOrdered = false
    var isPrepairToOrder = false
    var currentAddressViewDetail = 0
    var shouldUpdateScreen = false
    var shouldResetFrames = true
    
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
        setupFoodOrderInfoView()
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
        nextButton.setTitle(Localizable.Taxi.next.localized, for: .normal)
        mapButton.setTitle(Localizable.Taxi.map.localized, for: .normal)
        fromTextField.placeholder = Localizable.Taxi.fromAddressQuestion.localized
        toTextField.placeholder = Localizable.Taxi.toAddressQuestion.localized
        bottomSafeAreaConstant = view.safeAreaInsets.bottom
        if !menuView.isVisible && shouldResetFrames { resetFrames() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isTaxiOrdered {
            setupSetToLocationView()
            menuView.layoutSubviews()
            
            responderTextField?.becomeFirstResponder()
            
            MapKitManager.shared.checkLocationServices(delegate: self, view: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isTaxiOrdered {
            safeAreaBottomHeight = view.safeAreaInsets.bottom
                    
            if !menuView.isVisible {
                resetFrames()
            }
            userLocationButtonBottomConstraint.constant = foodTaxiView.bounds.height + promotionView.bounds.height + 20.0 - safeAreaBottomHeight
        }
        
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
    
    //MARK: - Configure Container view
    
    func configureContainerView(){
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.backgroundColor = .clear
        addChildVC()
        setContainerViewFrame(with: .search)
       
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 750),
//            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
    }
    func setContainerViewFrame(with state: ScreenState){
        switch state {
        case .search:
            containerView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.searchDriverScreenHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.searchDriverScreenHeight + bottomSafeAreaConstant)
        case .found:
            containerView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foundDriverScreenHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.foundDriverScreenHeight + bottomSafeAreaConstant)
        case .wait:
            containerView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.awaitDriverScreenHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.awaitDriverScreenHeight + bottomSafeAreaConstant + 30)
            
              if !hasSetPointOrigin {
                  hasSetPointOrigin = true
                  pointOrigin = self.containerView.frame.origin
             
              }
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
                  containerView.addGestureRecognizer(panGesture)
        }
    }
    
    func addChildVC(){
        let child = DriverSearchVC()
        child.toAddress = "Place A"
        child.fromAddress = "Place B"
        child.credits = 0
        child.paymentCard = 1
        child.promocodes = ["R-162860"]
        child.tariff = 3
        child.paymentMethod = "cash"
        child.delegate = self
        self.add(childVC: child, to: containerView)
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: containerView)

         // Not allowing the user to drag the view upward
         guard translation.y >= 0 else { return }

         // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
         containerView.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)

         if sender.state == .ended {
             let dragVelocity = sender.velocity(in: containerView)
             if dragVelocity.y >= 1300 {
               
                 isTaxiOrdered = true
                 isPrepairToOrder = false
                 pressTaxiOrderButton()
             } else {
                 // Set back to original position of the view controller
                 UIView.animate(withDuration: 0.3) {
                     self.containerView.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 300)
                 }
             }
         }
     }
    
    // MARK: - Taxi Methods
    
    func loadSetupsTaxi() {
        addressesChooserView.alpha = 1
        if !isTaxiOrdered {
            
            if isFoodOrdered {
                UIView.animate(withDuration: 0.5) {
                    self.foodOrderInfoView.frame.origin.y = self.view.frame.height
                    self.userLocationButtonOutlet.isHidden = false

                    
                }
            }
            
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
        
        taxiOrderInfoView.delegate = self
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(taxiInfoSwipeUp(_:)))
        swipeUp.direction = .up
        taxiOrderInfoView.addGestureRecognizer(swipeUp)
        
        mainScreenInteractor.setup(view: taxiOrderInfoView, for: view)
    }
    
    private func setupFoodOrderInfoView() {
        
        foodOrderInfoView.delegate = self
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(foodInfoSwipeUp(_:)))
        swipeUp.direction = .up
        foodOrderInfoView.addGestureRecognizer(swipeUp)
        
        mainScreenInteractor.setup(view: foodOrderInfoView, for: view)
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
                
                if self.isTaxiOrdered && self.isFoodOrdered {
                    
                    self.pathTimeBG.image = #imageLiteral(resourceName: "activeOrder")
                    self.timeLabel.text = "2 активных заказа"
                    self.pathTimeView.alpha = 1
                    self.foodTaxiView.taxiImageView.image = #imageLiteral(resourceName: "taxiButtonDisable")
                } else if self.isTaxiOrdered || self.isFoodOrdered {
                    self.pathTimeBG.image = #imageLiteral(resourceName: "activeOrder")
                    self.timeLabel.text = Localizable.FoodOrder.foodOrderOneActive.localized
                    self.pathTimeView.alpha = 1
                    self.foodTaxiView.taxiImageView.image = #imageLiteral(resourceName: "Taxi")
                }
                
                if !self.isTaxiOrdered && !self.isFoodOrdered {
                    self.foodTaxiView.taxiImageView.image = #imageLiteral(resourceName: "Taxi")
                    self.foodTaxiView.foodImageView.image = #imageLiteral(resourceName: "Food")
                    self.promotionView.alpha = 1
                    self.pathTimeView.alpha = 0
                }
                
                self.userLocationButtonOutlet.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
     func pressTaxiOrderButton() {
         
         UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
             self.containerView.frame.origin.y = self.view.frame.height - self.containerView.frame.height
             self.containerView.removeFromSuperview()
           
             self.view.layoutIfNeeded()
         }
      
        
        returnToMainView()
        promotionView.alpha = 0
    
        foodTaxiView.placeAnnotationView.alpha = 0
        foodTaxiView.placeLabel.text = ""
        
        taxiOrderInfoView.fromAddressTextField.text = fromAddress
        taxiOrderInfoView.toAddressTextField.text = toAddress
        if let tariffImage = mainScreenInteractor.getTaxiTariffImage(index: taxiTariffSelected) {
            taxiOrderInfoView.taxiTypeImageView.image = tariffImage
        }
        
        let time = "15"//timeRemainig ?? ""
        let fianlText = separationText.separation(input: Localizable.Taxi.remainingTime.localized, insert: time)
        let textCount = fianlText.count
        let typeAttributeText: [NSAttributedString.Key : Any] = [.foregroundColor : PaymentWaysColors.yellowColor.value]
        let textAttribute = createTextAttribute(inputText: fianlText, type: typeAttributeText,
                                                   locRus: 24, lenRus: textCount - 24,
                                                   locEng: 19, lenEng: textCount - 19)
        

        taxiOrderInfoView.taxiInfoTimeTextView.attributedText = textAttribute
        taxiOrderInfoView.taxiInfoTimeTextView.font = UIFont.SFUIDisplayRegular(size: 17.0)
        taxiOrderInfoView.taxiInfoTimeTextView.textAlignment = .center
        


        taxiTariffView.scoresEntered = 0
        promocodeScoresView.reset()
         promocodeScoresView.removeFromSuperview()
        
        if !isFoodOrdered && isTaxiOrdered {
            UIView.animate(withDuration: 1.5) {
                self.taxiOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 35
                self.taxiOrderInfoView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 1.5) {
                self.taxiOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 35
                self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 50
                self.taxiOrderInfoView.swipeLineImageView.alpha = 0
                self.taxiOrderInfoView.alpha = 1
            }
        }
        
    }
    
    func pressFoodOrderButton() {
        
        let time = "45"
        let fianlText = separationText.separation(input: Localizable.Food.deliverTime.localized, insert: time)
        let textCount = fianlText.count
        let typeAttributeText: [NSAttributedString.Key : Any] = [.foregroundColor : PaymentWaysColors.yellowColor.value]
        let textAttribute = createTextAttribute(inputText: fianlText, type: typeAttributeText,
                                                   locRus: 15, lenRus: textCount - 15,
                                                   locEng: 14, lenEng: textCount - 14)
        

        foodOrderInfoView.foodInfoTimeTextView.attributedText = textAttribute
        foodOrderInfoView.foodInfoTimeTextView.font = UIFont.SFUIDisplayRegular(size: 17.0)
        foodOrderInfoView.foodInfoTimeTextView.textAlignment = .center
        
        UIView.animate(withDuration: 0.5) {
            self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 35

            self.pathTimeBG.image = #imageLiteral(resourceName: "activeOrder")
            self.pathTimeView.alpha = 1
        }
        timeLabel.text = "1 активный заказ"
        
//        if isFoodOrdered && !isTaxiOrdered {
//
//        } else {
//            UIView.animate(withDuration: 0.5) {
//                self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 50
//                self.taxiOrderInfoView.swipeLineImageView.alpha = 0
//
//                self.pathTimeBG.image = #imageLiteral(resourceName: "activeOrder")
//                self.pathTimeView.alpha = 1
//            }
//            timeLabel.text = "2 активных заказа"
//
//        }
    }
    
    func animationSwipeUp() {

        UIView.animate(withDuration: 0.5) {
            let height:CGFloat = 170
            let lowPosY = self.view.frame.height - self.foodTaxiView.frame.height - height
            let highPosY = self.view.frame.height - self.foodTaxiView.frame.height - 2 * height - 15
            
            if self.isTaxiOrdered {
                self.taxiOrderInfoView.frame.origin.y = lowPosY
                if self.isFoodOrdered {
                    self.foodOrderInfoView.frame.origin.y = highPosY
                }
            } else {
                if self.isFoodOrdered {
                    self.foodOrderInfoView.frame.origin.y = lowPosY
                }
            }
        } completion: { _ in
            self.taxiOrderInfoView.gestureRecognizers?.removeAll()
            self.foodOrderInfoView.gestureRecognizers?.removeAll()
            self.addSwipeDownGesture()
            self.addTapGesture()
        }
    }
    
    func addSwipeDownGesture() {
        if self.isTaxiOrdered {
            
            let swipeDowm = UISwipeGestureRecognizer(target: self, action: #selector(self.taxiInfoSwipeDown(_:)))
            swipeDowm.direction = .down
            self.taxiOrderInfoView.addGestureRecognizer(swipeDowm)
        }
        
        if self.isFoodOrdered {
            
            let swipeDowm = UISwipeGestureRecognizer(target: self, action: #selector(self.taxiInfoSwipeDown(_:)))
            swipeDowm.direction = .down
            self.foodOrderInfoView.addGestureRecognizer(swipeDowm)
        }
    }
    
    func addTapGesture() {
        if self.isTaxiOrdered {

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.taxiOrderedInfoTap))
            self.taxiOrderInfoView.addGestureRecognizer(tap)
        }
        
        if self.isFoodOrdered {

            let tap = UITapGestureRecognizer(target: self, action: #selector(self.foodOrderedInfoTap))
            self.foodOrderInfoView.addGestureRecognizer(tap)
        }
    }
    
    func rollUpTaxiOrderInfo() {
        taxiOrderInfoView.gestureRecognizers?.removeAll()
        UIView.animate(withDuration: 0.5) {
            
            let height:CGFloat = 169
            
            self.foodTaxiView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height
            self.taxiOrderInfoView.frame.size.height = height
            self.taxiOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - height - 15
            
            if !self.isFoodOrdered {
                self.taxiOrderInfoView.swipeLineImageView.alpha = 1
            } else {
                self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 2 * height - 15
                self.foodOrderInfoView.swipeLineImageView.alpha = 1
            }
            
            self.mainScreenInteractor.animationTaxiOrderInfoLowPart(for: self.taxiOrderInfoView)

            self.view.layoutIfNeeded()
        }
    }
    
    func rollUpFoodOrderInfo() {
        
        foodOrderInfoView.gestureRecognizers?.removeAll()
        
        UIView.animate(withDuration: 0.5) {
            
            let height:CGFloat = 169
            
            self.foodTaxiView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height
            self.foodOrderInfoView.frame.size.height = height
            
            if self.isTaxiOrdered {
                self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 2 * height - 15
                self.taxiOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - height - 15
            } else {
                self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - height - 15
            }
            
            self.foodOrderInfoView.swipeLineImageView.alpha = 1

            
            self.mainScreenInteractor.animationFoodOrderInfoLowPart(for: self.foodOrderInfoView)

            self.view.layoutIfNeeded()
        }
    }
    
    func hideShowMenuButton() {
        UIView.animate(withDuration: 0.5) {
            if self.menuButton.alpha == 0 {
                self.menuButton.alpha = 1
                self.circleView.alpha = 1
            } else {
                self.menuButton.alpha = 0
                self.circleView.alpha = 0
            }
        }
    }
    
    func returnFromTaxiToStart() {
        
        UIView.animate(withDuration: 1) {
            self.promotionView.alpha = 1
            if self.isFoodOrdered {
                self.foodOrderInfoView.frame.origin.y = self.view.frame.height - self.foodTaxiView.frame.height - 35
            }
        }
        
        returnToMainView()
        promocodeScoresView.removeFromSuperview()
        roundedView.frame.origin.y = self.view.bounds.height
        roundedViewTopConstraint.priority = .required
        roundedViewBottomConstraint.priority = .defaultLow
        taxiTariffView.removeFromSuperview()
        userLocationButtonBottomConstraint.constant = foodTaxiView.bounds.height + promotionView.bounds.height + 20.0 - safeAreaBottomHeight

        fromTextField.isUserInteractionEnabled = true
        toTextField.isUserInteractionEnabled = true
        shouldMakeOrder = false
        addresses.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        SetMapMarkersManager.shared.isPathCalculeted = false
        isTaxiOrdered = false
        isPrepairToOrder = false
        SetMapMarkersManager.shared.isFromAddressMarkSelected = true
        MapKitManager.shared.locationManager.startUpdatingLocation()
        toAddress = ""
        fromAddress = ""
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @objc Taxi Methods
    
    @objc
    func foodInfoSwipeUp(_ recognizer: UISwipeGestureRecognizer) {
        
        if taxiOrderInfoView.frame.height == 169 {
            if recognizer.state == .ended {
                animationSwipeUp()
            }
        }
    }
    
    @objc
    func taxiInfoSwipeUp(_ recognizer: UISwipeGestureRecognizer) {
        
        if taxiOrderInfoView.frame.height == 169 {
            if recognizer.state == .ended {
                animationSwipeUp()
            }
        }
    }
    
    @objc
    private func taxiInfoSwipeDown(_ recognizer: UISwipeGestureRecognizer) {
        if taxiOrderInfoView.frame.height == 169 || foodOrderInfoView.frame.height == 169 {
            if recognizer.state == .ended {
                
                UIView.animate(withDuration: 0.5) {
                    
                    let lowPosY = self.view.frame.height - self.foodTaxiView.frame.height - 35
                    let highPosY = self.view.frame.height - self.foodTaxiView.frame.height - 50
                    
                    if self.isTaxiOrdered {
                        self.taxiOrderInfoView.frame.origin.y = lowPosY
                        if self.isFoodOrdered {
                            self.foodOrderInfoView.frame.origin.y = highPosY
                        }
                    } else {
                        if self.isFoodOrdered {
                            self.foodOrderInfoView.frame.origin.y = lowPosY
                        }
                    }

                } completion: { _ in
                    self.taxiOrderInfoView.gestureRecognizers?.removeAll()
                    self.foodOrderInfoView.gestureRecognizers?.removeAll()
                    
                    if self.isTaxiOrdered {
                        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.taxiInfoSwipeUp(_:)))
                        swipeUp.direction = .up
                        self.taxiOrderInfoView.addGestureRecognizer(swipeUp)
                    }
                    
                    if self.isFoodOrdered {
                        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.foodInfoSwipeUp(_:)))
                        swipeUp.direction = .up
                        self.foodOrderInfoView.addGestureRecognizer(swipeUp)
                    }
                }
            }
        }
    }
    
    @objc
    private func taxiOrderedInfoTap() {
        
        hideShowMenuButton()
        
        if taxiOrderInfoView.frame.height == 169 {
            
            taxiOrderInfoView.gestureRecognizers?.removeAll()
            addTapGesture()
            
            UIView.animate(withDuration: 0.5) {
                
                let height:CGFloat = 434
                
                self.foodTaxiView.frame.origin.y = self.view.frame.height
                self.taxiOrderInfoView.frame.size.height = height
                
                let posY = self.view.frame.height - height
                self.taxiOrderInfoView.frame.origin.y = posY
                
                self.taxiOrderInfoView.swipeLineImageView.alpha = 0
                
                self.mainScreenInteractor.animationTaxiOrderInfoLowPart(for: self.taxiOrderInfoView)
                
                if self.isFoodOrdered {
                    self.taxiOrderInfoView.addDeliveryButtonOutlet.isEnabled = false
                    self.taxiOrderInfoView.addDeliveryButtonOutlet.backgroundColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1)
                    self.foodOrderInfoView.frame.origin.y = posY
                    self.foodOrderInfoView.swipeLineImageView.alpha = 0
                } else {
                    self.taxiOrderInfoView.addDeliveryButtonOutlet.isEnabled = true
                    self.taxiOrderInfoView.addDeliveryButtonOutlet.backgroundColor = UIColor(red: 0.239, green: 0.231, blue: 1, alpha: 1)
                }
                
                self.view.layoutIfNeeded()
            }
        } else {
            rollUpTaxiOrderInfo()
            addTapGesture()
            addSwipeDownGesture()
            
        }
    }
    
    @objc
    private func foodOrderedInfoTap() {
        
        hideShowMenuButton()
        
        if foodOrderInfoView.frame.height == 169 {
            foodOrderInfoView.gestureRecognizers?.removeAll()
            addTapGesture()
            UIView.animate(withDuration: 0.5) {
                
                let height:CGFloat = 350
                
                self.foodTaxiView.frame.origin.y = self.view.frame.height
                self.foodOrderInfoView.frame.size.height = height
                
                let posY = self.view.frame.height - height
                self.foodOrderInfoView.frame.origin.y = posY
                
                self.foodOrderInfoView.swipeLineImageView.alpha = 0
                
                self.mainScreenInteractor.animationFoodOrderInfoLowPart(for: self.foodOrderInfoView)
                
                if self.isTaxiOrdered {
                    self.taxiOrderInfoView.frame.origin.y = self.view.frame.height
                }
                
                self.view.layoutIfNeeded()
            }
        } else {
            rollUpFoodOrderInfo()
            addTapGesture()
            addSwipeDownGesture()
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
        
        if !isTaxiOrdered && !isPrepairToOrder {
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
    
    @objc
    private func closeMenuView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            close()
        }
    }
    
    @objc
    func tapToTransparentView() {
        if isPrepairToOrder {
            switch currentAddressViewDetail {
            case 1:
                UIView.animate(withDuration: 0.5) {
                    self.fromAddressDetailView.frame.origin.x = self.view.frame.width
                }
                
            case 2:
                UIView.animate(withDuration: 0.5) {
                    self.toAddressDetailView.frame.origin.x = self.view.frame.width
                }
            default:
                break
            }
            currentAddressViewDetail = 0
        }
        moveDown()
        returnFromTaxiToStart()
    }
    
    //MARK: - Helper
    
    func resetFrames() {
        menuView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width - MainScreenConstants.menuViewXOffset, height: view.bounds.height)
        foodTaxiView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.foodTaxiViewHeight + bottomSafeAreaConstant)
        if promotionView.superview != nil {
            promotionView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - MainScreenConstants.foodTaxiYOffset - bottomSafeAreaConstant - MainScreenConstants.promotionViewHeight, width: view.bounds.width, height: MainScreenConstants.promotionViewHeight)
        }
        if deliveryMainView.superview != nil {
            deliveryMainView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - MainScreenConstants.foodTaxiYOffset - bottomSafeAreaConstant - MainScreenConstants.promotionViewHeight, width: view.bounds.width, height: 45.0)
        }
        promotionDetailView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
    }
    
    func placeContainerView() {
        
        UIView.animate(withDuration: 0.5) {
            self.addressesChooserView.frame.origin.y = self.view.frame.height
            self.addressesChooserView.alpha = 0
            self.taxiBackButtonOutlet.alpha = 0
            self.circleView.alpha = 0
            self.promotionView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.configureContainerView()
        }
   
    }
    
    func prepareForShowFoodOrderView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showFoodOrderView()
        }
        
    }
    
    private func showFoodOrderView() {
        transparentView.isHidden = true
        mapView.isUserInteractionEnabled = false
        menuButton.isUserInteractionEnabled = false
        profileButton.isUserInteractionEnabled = false
        view.addSubview(orderCompleteView)
        orderCompleteView.delegate = self
        orderCompleteView.reset()
        orderCompleteView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 380)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.orderCompleteView.frame.origin.y = self.view.bounds.height - 380
        }
    }
    
    // MARK: - Actions
    
    @IBAction func next(_ sender: UIButton) {
        
        if isTaxiOrdered {
        
            roundedView.isUserInteractionEnabled = true
            print("place container")
           // pressTaxiOrderButton()
            placeContainerView()
            pathTimeView.alpha = 0
            taxiBackButtonOutlet.alpha = 1
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.view.layoutIfNeeded()
            }
        }

        if shouldMakeOrder {
            
            addressesChooserViewHeightConstraint.constant = 370 + safeAreaBottomHeight
            if taxiTariffView.superview == nil { addressesChooserView.addSubview(taxiTariffView) }
            addressesChooserView.addSubview(promocodeScoresView)
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
            transparentView.isHidden = true
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
                self.view.layoutIfNeeded()
            }
            promocodeScoresView.frame.size.height = 50.0
            isTaxiOrdered = true

        } else {
            
            moveDown()
            isPrepairToOrder = true
            currentAddressViewDetail = 1
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
            //userLocationButtonBottomConstraint.constant = fromAddressDetailView.bounds.height + keyboardHeight - safeAreaBottomHeight
            
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
        menuView.isVisible = true
        shouldUpdateScreen = false
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
                self.deliveryMainView.frame.origin.y = self.view.bounds.height
            })
        
        if isTaxiOrdered {
            UIView.animate(withDuration: 0.5) {
                self.taxiOrderInfoView.frame.origin.y = self.view.frame.height
            }
        }
        
        if isFoodOrdered {
            UIView.animate(withDuration: 0.5) {
                self.foodOrderInfoView.frame.origin.y = self.view.frame.height
            }
        }
    }
    
    @IBAction func goToProfile(_ sender: UIButton) {
        goToStoryboard("UserProfile")
    }
    
    @IBAction func userLocationButtonAction(_ sender: Any) {
        MapKitManager.shared.locationManager.startUpdatingLocation()
        UIView.animate(withDuration: 0.5) {
            self.userLocationButtonOutlet.alpha = 0
        }
    }
    
    @IBAction func taxiBackButtonAction(_ sender: UIButton) {
        returnFromTaxiToStart()
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

    func showTaxiCompletedView(){
        transparentView.isHidden = true
        mapView.isUserInteractionEnabled = false
        menuButton.isUserInteractionEnabled = false
        profileButton.isUserInteractionEnabled = false
        view.addSubview(orderCompleteView)
        orderCompleteView.currentOrderType = .taxi
        orderCompleteView.delegate = self        
        orderCompleteView.reset()
        orderCompleteView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 380)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.closeContainerView()
            self.orderCompleteView.frame.origin.y = self.view.bounds.height - 380
        }
    }
    
    // MARK: Dismiss taxiContainerView and return to the main screen
    func closeContainerView(){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.containerView.frame.origin.y = self.view.frame.height
            for i in self.containerView.subviews{
                i.removeFromSuperview()
            }
            self.containerView.removeFromSuperview()
           
            self.returnFromTaxiToStart()
           
        self.view.layoutIfNeeded()
    }
    }
    
    @IBAction func unwindSegueFromSupport(_ segue: UIStoryboardSegue) {
        close()
    }
    
}
