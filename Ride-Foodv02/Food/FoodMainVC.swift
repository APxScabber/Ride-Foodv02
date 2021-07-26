import UIKit

class FoodMainVC: UIViewController {

    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoCornerRoundedView: UIView!
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        confirmButton.isUserInteractionEnabled = false
    }}
    
    @IBOutlet weak var mapButton: UIButton! { didSet {
        mapButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func confirm(_ sender: UIButton) {
        
    }
    
    
    @IBAction func goToMap(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twoCornerRoundedView.layer.cornerRadius = 15.0
        twoCornerRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintWith(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func updateConstraintWith(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= size.height
        }
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
    
    
}
