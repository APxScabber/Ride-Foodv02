import UIKit
import MapKit

class MainScreenViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView! { didSet {
        let center = CLLocationCoordinate2D(latitude: 50, longitude: 50)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }}
    
    // MARK: - IBActions
    
    @IBAction func goToMenu(_ sender: MenuButton) {
        
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: Bundle.main)
        if let menuVC = menuStoryboard.instantiateInitialViewController()?.contents as? MenuTableViewController, let menuVCView = menuVC.view {

            menuVCView.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width - 42, height: self.view.bounds.height)
            view.addSubview(menuVCView)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: 0,
                options: .curveLinear,
                animations: { menuVCView.frame.origin.x += self.view.bounds.width  }) {
                if $0 == .end { }
            }
        }
        
        
    }
    
    
    // MARK: - Properties

    var userID: String?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
