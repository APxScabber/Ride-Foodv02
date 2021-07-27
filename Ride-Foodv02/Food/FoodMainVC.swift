import UIKit
import MapKit

protocol FoodMainDelegate: AnyObject {
    func done()
}

class FoodMainVC: UIViewController {

    //MARK: - API
    var place = String() { didSet { updateUI() }}
    var region = MKCoordinateRegion()
    weak var delegate: FoodMainDelegate?
    //MARK: - Outlets
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
    }}
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoCornerRoundedView: UIView!
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var mapButton: UIButton! { didSet {
        mapButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var textField: UITextField! 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBAction func goToMap(_ sender: UIButton) {
        
    }
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        twoCornerRoundedView.layer.cornerRadius = 15.0
        twoCornerRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintWith(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(done))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        updateUI()
    }
    
    @objc private func updateConstraintWith(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= size.height
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shops",
           let destination = segue.destination as? ShopListViewController,
           let cell = sender as? FoodMainTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            destination.place = testPlaces[indexPath.row]
            destination.address = testAdresses[indexPath.row]
        }
        if segue.identifier == "shopList",
           let destination = segue.destination as? ShopListViewController {
            destination.place = place
        }
        if segue.identifier == "locationChooserVC",
           let destination = segue.destination as? LocationChooserViewController {
            destination.region = region
            destination.delegate = self
        }
    }
    
    @objc
    private func done() {
        dismiss(animated: true)
        delegate?.done()
    }
    
    
    private func updateUI() {
        roundedView?.colorToFill = place.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        confirmButton?.isUserInteractionEnabled = !place.isEmpty
        textField?.text = place
    }
}

private let testPlaces = ["Дом","Работа","Баня","Футбол"]
private let testAdresses = ["Кутузовский проспект 14к3","Профсоюзная улица 18","Нагатинская пойма 13","Вагоноремонтная улица 54"]

extension FoodMainVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodMainCell", for: indexPath)
        if let foodMainCell = cell as? FoodMainTableViewCell {
            foodMainCell.placeLabel.text = testPlaces[indexPath.row]
            foodMainCell.addressLabel.text = testAdresses[indexPath.row]
            return foodMainCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - LocationChooserDelegate

extension FoodMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        place = newLocation
    }
    
    
}
