import UIKit
import MapKit
import CoreLocation

class MainScreenViewController: UIViewController {
    
    // MARK: - Outlets

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
    // MARK: - XIB files
    
    private let menuView = MenuView.initFromNib()
    private let foodTaxiView = FoodTaxiView.initFromNib()
    private let promotionView = PromotionView.initFromNib()
    
    // MARK: - IBActions
    
    @IBAction func goToMenu(_ sender: MenuButton) {
        transparentView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForAppearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.menuView.frame.origin.x += self.view.bounds.width
                self.foodTaxiView.frame.origin.y += (MainScreenConstants.foodTaxiViewHeight + self.bottomSafeAreaConstant)
                self.promotionView.frame.origin.y += (MainScreenConstants.promotionViewYOffset + self.bottomSafeAreaConstant)
            }) {
            if $0 == .end { self.menuView.isVisible = true }
        }
    }
    
    @IBAction func goToMainScreen(_ segue: UIStoryboardSegue) {}
    
    // MARK: - Properties

    var userID: String?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.delegate = self
        foodTaxiView.delegate = self
        view.addSubview(menuView)
        view.addSubview(foodTaxiView)
        view.addSubview(promotionView)
        CoreDataManager.shared.fetchCoreData { [weak self] result in
            
            switch result {
            case .success(let model):
                let userData = model.first
                self?.userID = String(describing: userData!.id!)
                print(self!.userID!)
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    
        
        guard let id = userID else { return }
        loadTariffs(userID: id)
    }
    
    private var bottomSafeAreaConstant: CGFloat = 0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomSafeAreaConstant = view.safeAreaInsets.bottom
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !menuView.isVisible {
            menuView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width - MainScreenConstants.menuViewXOffset, height: view.bounds.height)
        }
        foodTaxiView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.foodTaxiViewHeight - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.foodTaxiViewHeight + bottomSafeAreaConstant)
        promotionView.frame = CGRect(x: 0, y: view.bounds.height - MainScreenConstants.promotionViewYOffset - bottomSafeAreaConstant, width: view.bounds.width, height: MainScreenConstants.promotionViewHeight)
    }
    
    func loadTariffs(userID: String) {
        
        let urlString = separategURL(url: tariffsURL, userID: userID)
        guard let url = URL(string: urlString) else { return }
        
        LoadManager.shared.loadData(of: TariffsDataModel.self,
                                    from: url, httpMethod: .get, passData: nil) { result in
            switch result {
            case .success(let dataModel):
                let model = dataModel.data
                print("Тариф: \(model.name)")
                print("Автомобили: \(model.cars)")
                print("Описание: \(model.description)")
            case .failure(let error):
                print("Tariffs error: \(error.localizedDescription)")
            }
        }
    }
    
    //Разбиваем текст по компонентам использую ключ в виде @#^
    func separategURL(url: String, userID: String) -> String {
        
        let textArray = url.components(separatedBy: "@#^")
        let finalUrl = textArray[0] + userID + textArray[1]
        
        return finalUrl
    }
    
    @objc
    private func closeMenuView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            close()
        }
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
            
            findAddressAt(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
    }
    
    private func findAddressAt(_ location:CLLocation) {
        DispatchQueue.global(qos: .userInitiated).async {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, Error in
                if let foundPlacemark = placemarks?.first {
                    DispatchQueue.main.async { [weak self] in
                        self?.foodTaxiView.placeLabel.text = foundPlacemark.name
                        self?.foodTaxiView.placeAnnotationView.isHidden = false
                    }
                }
            }
        }
    }
    
}


extension MainScreenViewController: MenuViewDelegate {

    func close() {
        transparentView.isHidden = true
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: MainScreenConstants.durationForDisappearingMenuView,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.menuView.frame.origin.x -= self.view.bounds.width
                self.foodTaxiView.frame.origin.y -= (MainScreenConstants.foodTaxiViewHeight + self.bottomSafeAreaConstant)
                self.promotionView.frame.origin.y -= (MainScreenConstants.promotionViewYOffset + self.bottomSafeAreaConstant)
            }) {
            if $0 == .end { self.menuView.isVisible = false }
        }
    }
    
    func goToStoryboard(_ name:String) {
        let storyboard = UIStoryboard(name: name, bundle: .main)
        if let supportVC = storyboard.instantiateInitialViewController() as? UINavigationController {
            supportVC.modalPresentationStyle = .fullScreen
            supportVC.modalTransitionStyle = .coverVertical
            present(supportVC, animated: true)
        }
    }
    
}


extension MainScreenViewController: FoodTaxiViewDelegate {
    
    func goToFood() {
        
    }
    
    func goToTaxi() {
        
    }
    
    
}


extension MainScreenViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.image = UIImage(named: "Annotation")
        annotationView.frame.size = CGSize(width: 30, height: 48)
        return annotationView
    }
    
}
