import UIKit
import MapKit

protocol FoodMainDelegate: AnyObject {
    func done()
}

class FoodMainVC: UIViewController {
    

    //MARK: - API
    
    var localaddresses =  [UserAddressMO]()
    var remoteAddresses =  [AddressData]()
    
    var place = String() { didSet { updateUI() }}
    var region = MKCoordinateRegion()
    weak var delegate: FoodMainDelegate?
    
    private var keyboardHeight: CGFloat = 0
    private var shouldUseRemoteAddresses = false
    
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
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! { didSet {
        tableViewHeightConstraint.constant = 0 
    }}
    
    //MARK: - Actions
    
    @IBAction func goToMap(_ sender: UIButton) { }
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activateKeyboardNotification()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(done))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        CurrentAddress.shared.place = ""
        CurrentAddress.shared.address = ""
        fetch()
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
        vc.delegate = self
        NotificationCenter.default.removeObserver(self)
        present(vc, animated: true)
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
    
    private func activateKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintWith(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: - Fetch addresses
    
    private func getAddressesFromServer() {
        
        AddressesNetworkManager.shared.getTheAddresses { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    
                    if !data.isEmpty {
                        self.shouldUseRemoteAddresses = true
                        PersistanceManager.shared.createCoreDataInstance(addressesToCopy: self.remoteAddresses, view: self)
                        self.remoteAddresses = data
                        self.tableView.reloadData()
                        self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(self.remoteAddresses.count,3))
                    }
                    print(data)
                }
            default:break
            }
        }
    }
    
    private func fetch(){

        PersistanceManager.shared.fetchAddresses { result in
            switch result{
            case .success(let data):
                
                if data.isEmpty {
                    self.getAddressesFromServer()
                } else {
                    DispatchQueue.main.async {
                        self.localaddresses = data
                        self.tableView.reloadData()
                        self.tableViewHeightConstraint.constant = FoodConstants.tableViewRowHeight * CGFloat(min(self.localaddresses.count,3))
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - ShopListDelegate

extension FoodMainVC: ShopListDelegate {
    
    func syncUI() {
        activateKeyboardNotification()
    }
    
}

//MARK: - UITableViewDataSource

extension FoodMainVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldUseRemoteAddresses ? remoteAddresses.count : localaddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodMainCell", for: indexPath)
        if let foodMainCell = cell as? FoodMainTableViewCell {
            if shouldUseRemoteAddresses {
                foodMainCell.placeLabel.text = remoteAddresses[indexPath.row].name ?? ""
                foodMainCell.addressLabel.text = remoteAddresses[indexPath.row].address ?? ""
            } else {
                foodMainCell.placeLabel.text = localaddresses[indexPath.row].title ?? ""
                foodMainCell.addressLabel.text = localaddresses[indexPath.row].fullAddress ?? ""
            }
            
            return foodMainCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldUseRemoteAddresses {
            CurrentAddress.shared.place = remoteAddresses[indexPath.row].name ?? ""
            CurrentAddress.shared.address = remoteAddresses[indexPath.row].address ?? ""
        } else {
            CurrentAddress.shared.place = localaddresses[indexPath.row].title ?? ""
            CurrentAddress.shared.address = localaddresses[indexPath.row].fullAddress ?? ""
        }
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
