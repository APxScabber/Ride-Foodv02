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
        textField.text = place
    }
    
  

    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shops",
           let destination = segue.destination as? ShopListViewController,
           let cell = sender as? FoodMainTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            destination.place = addresses[indexPath.row].title
            destination.address = addresses[indexPath.row].fullAddress
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

    @IBAction func goToTheShopList(_ sender: Any) {
        goToTheShopListVC(sender: nil, indexPath: nil)
    }
    
    
    func goToTheShopListVC(sender: Any?, indexPath: IndexPath?){
        
      if sender is FoodMainTableViewCell, let indexPath = indexPath{
            let address = addresses[indexPath.row]
            let storyboard = UIStoryboard(name: "Food", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "shopListVC") as! ShopListViewController
           
            vc.place = address.title
            vc.address = address.fullAddress
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.present(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Food", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "shopListVC") as! ShopListViewController
            vc.place = place
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.present(vc, animated: true)
        }
       
    }
    
    //MARK: - UI changes
    @objc
    private func updateUI() {
        roundedView?.colorToFill = place.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        underbarLineView?.backgroundColor = place.isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        confirmButton?.isUserInteractionEnabled = !place.isEmpty
    }
    
    private var shouldMoveView: Bool? = true
    
    @objc private func updateConstraintWith(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard shouldMoveView != nil else { return }
        if let size = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= size.height
            shouldMoveView = nil
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
        dismiss(animated: true)
        delegate?.done()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodMainCell", for: indexPath)
        if let foodMainCell = cell as? FoodMainTableViewCell {
            goToTheShopListVC(sender: foodMainCell, indexPath: indexPath)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
   
    
}

//MARK: - LocationChooserDelegate

extension FoodMainVC: LocationChooserDelegate {
    
    func locationChoosen(_ newLocation: String) {
        place = newLocation
        textField?.text = place
    }
    
    
}

extension FoodMainVC: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, viewHeightMultiplierPercentage: 0.11)
    }
}
