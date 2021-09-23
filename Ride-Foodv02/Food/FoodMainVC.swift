import UIKit
import MapKit

protocol FoodMainDelegate: AnyObject {
    func done()
}

class FoodMainVC: UIViewController {
    


    //MARK: - API
    var addresses = [Address]()
    var place = String() { didSet { updateUI() }}
    var region = MKCoordinateRegion()
    weak var delegate: FoodMainDelegate?
    
    private var keyboardHeight: CGFloat = 0
    
    //MARK: - Outlets
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
    }}
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoCornerRoundedView: TopRoundedView!
    @IBOutlet weak var underbarLineView: UIView!
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        confirmButton.setTitle(Localizable.Food.confirm.localized, for: .normal)
    }}
    
    @IBOutlet weak var mapButton: UIButton! { didSet {
        mapButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 12.0)
        mapButton.setTitle(Localizable.Food.map.localized, for: .normal)
    }}
    @IBOutlet weak var textField: UITextField! { didSet {
        textField.placeholder = Localizable.Food.enterAdress.localized
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Actions
    
    @IBAction func goToMap(_ sender: UIButton) { }
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintWith(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
                
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(done))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        CurrentAddress.shared.place = ""
        CurrentAddress.shared.address = ""
        PersistanceManager.shared.fetchAddresses { result in
            switch result {
            case .success(let addresses):
                addresses.forEach {
                    self.addresses.append(Address(title: $0.title ?? "", fullAddress: $0.fullAddress ?? ""))
                }
                self.tableView.reloadData()
                self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(addresses.count,3))
            default:break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        updateViewConstraints()
    }
    
  

    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationChooser",
           let destination = segue.destination as? LocationChooserViewController {
            destination.region = region
            destination.delegate = self
        }
    }

    @IBAction func goToTheShopList(_ sender: Any) {
        CurrentAddress.shared.place = ""
        CurrentAddress.shared.address = textField.text ?? ""
        goToTheShopListVC()
    }
    
    
    func goToTheShopListVC(){
        moveDown()
        let storyboard = UIStoryboard(name: "Food", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "shopListVC") as! ShopListViewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true)
    }
    
    //MARK: - UI changes
    @objc
    private func updateUI() {
        textField?.text = place
        roundedView?.colorToFill = place.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        underbarLineView?.backgroundColor = place.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        confirmButton?.isUserInteractionEnabled = !place.isEmpty
    }
        
    @objc private func updateConstraintWith(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard let superview = view.superview else { return }
            self.view.frame.origin.y = superview.frame.height - size.height - self.view.bounds.height
            keyboardHeight = size.height
        }
    }


    @objc
    private func textFieldChanged() {
        place = textField?.text ?? ""
        updateUI()
    }
    
    //MARK: - Helpers
    
    @objc
    private func done() {
        if keyboardHeight == 0 {
            dismiss(animated: true)
            delegate?.done()
        } else {
            moveDown()
        }
    }
    
    private func moveDown() {
        textField.resignFirstResponder()
        keyboardHeight = 0
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.y = self.view.superview!.frame.height - self.view.bounds.height
        }
    }
    
}


extension FoodMainVC: UITableViewDataSource, UITableViewDelegate {
    
    
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
        CurrentAddress.shared.place = addresses[indexPath.row].title
        CurrentAddress.shared.address = addresses[indexPath.row].fullAddress
        goToTheShopListVC()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   
    
}

//MARK: - LocationChooserDelegate

extension FoodMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        place = newLocation
        textField.text = place
        CurrentAddress.shared.place = ""
        CurrentAddress.shared.address = newLocation
    }
    
    
}

//MARK: - UIViewControllerTransitioningDelegate

extension FoodMainVC: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, viewHeightMultiplierPercentage: 0.11)
    }
}
