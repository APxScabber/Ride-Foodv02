import UIKit
import MapKit
import CoreLocation

class MainScreenViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userLocationButtonOutlet: UIButton! { didSet{
        userLocationButtonOutlet.alpha = 0
    }}

    @IBOutlet weak var userLocationButtonConstraint: NSLayoutConstraint! { didSet {
        userLocationButtonConstraint.constant = foodTaxiView.frame.height + promotionView.touchableView.frame.height + 20
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenuView(_:)))
        transparentView.addGestureRecognizer(tapGesture)
    }}
    
    @IBOutlet weak var circleView: CircleView! { didSet {
        circleView.color = .white
    }}
    
    @IBOutlet weak var menuButton: UIButton! { didSet {
        menuButton.isExclusiveTouch = true
    }}
    
    // MARK: - XIB files
    
    private let menuView = MenuView.initFromNib()
    let foodTaxiView = FoodTaxiView.initFromNib()
    let promotionView = PromotionView.initFromNib()
    let promotionDetailView = PromotionDetail.initFromNib()
    
    // MARK: - IBActions
    
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
    
    @IBAction func goToMainScreen(_ segue: UIStoryboardSegue) {}
    
    
    @IBAction func userLocationButtonAction(_ sender: Any) {
        MapKitManager.shared.locationManager.startUpdatingLocation()
        userLocationButtonOutlet.alpha = 0
    }
    
    // MARK: - Properties

    private var bottomSafeAreaConstant: CGFloat = 0

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
        menuView.layoutSubviews()

        MapKitManager.shared.checkLocationServices(delegate: self, view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !menuView.isVisible {
            resetFrames()
        }
    }
    
    // MARK: - Methods
    
    func animationUerLocationButton() {
        
        let safeAreaBottomHeight = view.safeAreaInsets.bottom
        
        userLocationButtonConstraint.constant = foodTaxiView.frame.height - safeAreaBottomHeight
        
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
        } else if segue.identifier == "taxi",
                  let destination = segue.destination as? TaxiMainVC {
            destination.fromAddress = foodTaxiView.placeLabel.text ?? ""
            MapKitManager.shared.currentUserCoordinate = mapView.annotations.first?.coordinate
        }
    }
    
    //MARK: - MapView
    
    @objc
    private func mapViewTouched(_ recognizer: UITapGestureRecognizer) {
        
        if recognizer.state == .ended {

            let location = recognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            if let userLocation = MapKitManager.shared.currentUserCoordinate {
                
                userLocationButtonOutlet.alpha = userLocation == coordinate ? 0 : 1
            }

            SetMapMarkersManager.shared.setMarkOn(map: mapView, with: coordinate) { address in
                self.foodTaxiView.placeLabel.text = address
            }
        }
    }
    
    //MARK: - Helper
    
    @objc
    private func closeMenuView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            close()
        }
    }
    
    private func resetFrames() {
        menuView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width - MainScreenConstants.menuViewXOffset, height: view.bounds.height)
        foodTaxiView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.foodTaxiViewHeight + bottomSafeAreaConstant)
        promotionView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - MainScreenConstants.foodTaxiYOffset - bottomSafeAreaConstant - MainScreenConstants.promotionViewHeight, width: view.bounds.width, height: MainScreenConstants.promotionViewHeight)
        promotionDetailView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
    }
}

//MARK: - MenuViewDelegate

extension MainScreenViewController: MenuViewDelegate {

    func close() {
        transparentView.isHidden = true
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForDisappearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.resetFrames()
            }) {
            if $0 == .end { self.menuView.isVisible = false }
        }
    }
    
    func goToStoryboard(_ name:String) {
        let storyboard = UIStoryboard(name: name, bundle: .main)
        if let supportVC = storyboard.instantiateInitialViewController() {
            supportVC.modalPresentationStyle = .fullScreen
            supportVC.modalTransitionStyle = .coverVertical
            present(supportVC, animated: true)
        }
    }
}

//MARK: - FoodTaxiView Delegate

extension MainScreenViewController: FoodTaxiViewDelegate {
    
    func goToFood() {
        UIView.animate(withDuration: MainScreenConstants.durationForAppearingPromotionView) {
            self.promotionView.alpha = 0
        }
        performSegue(withIdentifier: "food", sender: nil)
    }
    
    func goToTaxi() {
        performSegue(withIdentifier: "taxi", sender: nil)
    }
}

//MARK: - PromotionDetail Delegate

extension MainScreenViewController: PromotionDetailDelegate {
    
    func dismiss() {
        transparentView.isHidden = true
        circleView.isHidden = false
        menuButton.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForAppearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.resetFrames()
            })
    }
}

//MARK: - FoodMainDelegate

extension MainScreenViewController: FoodMainDelegate {
    
    func done() {
        transparentView.isHidden = true
        UIView.animate(withDuration: MainScreenConstants.durationForAppearingPromotionView) {
            self.promotionView.alpha = 1
        }
    }
}
