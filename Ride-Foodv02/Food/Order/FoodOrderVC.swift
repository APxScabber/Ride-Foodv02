import UIKit

class FoodOrderVC: BaseViewController {

    //MARK: - API
    
    private var paymentWays = [Localizable.FoodOrder.foodOrderCash.localized,"Apple Pay"]
    private var paymentImages: [UIImage] = [#imageLiteral(resourceName: "cash"),#imageLiteral(resourceName: "applePay")]
    private var selectedIndex: IndexPath?
    
    var totalPrice = 0
    
    //MARK: - Outlets
    
    private let cashBackNeededView = CashBackNeededView.initFromNib()
    
    @IBOutlet weak var checkoutLabel: UILabel! { didSet {
        checkoutLabel.font = UIFont.SFUIDisplaySemibold(size: 15.0)
        checkoutLabel.text = Localizable.FoodOrder.foodOrderCheckout.localized
    }}
    
    @IBOutlet weak var deliveryAddressLabel: UILabel! { didSet {
        deliveryAddressLabel.font = UIFont.SFUIDisplaySemibold(size: 15.0)
        deliveryAddressLabel.text = Localizable.FoodOrder.foodOrderDeliveryAddress.localized
    }}
    
    @IBOutlet  weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var addressLabel: UILabel! { didSet {
        addressLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var paymentWaysLabel: UILabel! { didSet {
        paymentWaysLabel.font = UIFont.SFUIDisplaySemibold(size: 15.0)
        paymentWaysLabel.text = Localizable.FoodOrder.foodOrderPaymentWays.localized
    }}
    
    @IBOutlet weak var cashbackLabel: UILabel! { didSet {
        cashbackLabel.font = UIFont.SFUIDisplayLight(size: 17.0)
    }}
    
    @IBOutlet weak var cashbackValueLabel: UILabel! { didSet {
        cashbackValueLabel.font = UIFont.SFUIDisplayLight(size: 17.0)
    }}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topRoundedView: TopRoundedView! { didSet {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(closeVC(_:)))
        swipe.direction = .down
        topRoundedView.addGestureRecognizer(swipe)
    }}
    @IBOutlet weak var cashbackView: UIView! { didSet {
        cashbackView.isHidden = true
    }}
    
    @IBOutlet weak var bottomRoundedView: RoundedView! { didSet {
        bottomRoundedView.cornerRadius = 15.0
        bottomRoundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    @IBOutlet weak var transparentView: TopRoundedView!
    
    @IBOutlet weak var paymentButton: UIButton! { didSet {
        paymentButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        paymentButton.setTitle(Localizable.FoodOrder.foodOrderPay.localized, for: .normal)
    }}
    
    @IBOutlet weak var totalPriceLabel: UILabel! { didSet {
        totalPriceLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
        totalPriceLabel.text = "\(totalPrice) \(Localizable.FoodOrder.foodOrderMoney.localized)"
    }}
    
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint! { didSet {
        containerViewHeightConstraint.constant = 350.0
    }}
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cashBackViewHeightConstraint: NSLayoutConstraint! { didSet {
        cashBackViewHeightConstraint.constant = 0.0
    }}
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! { didSet {
        bottomConstraint.constant = 10 + CGFloat(SafeArea.shared.bottom)
    }}
    //MARK: - Actions
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func order(_ sender: UIButton) {
        
    }
    
    @IBAction func goToCashbackNeededView(_ sender: UIButton) {
        cashBackNeededView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 175)
        transparentView.isHidden = false
        cashBackNeededView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
            self.cashBackNeededView.frame.origin.y = self.view.bounds.height - self.cashBackNeededView.bounds.height
        }

    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cashBackNeededView.isHidden = true
        cashBackNeededView.delegate = self
        view.addSubview(cashBackNeededView)
        placeLabel.text = CurrentAddress.shared.place
        addressLabel.text = CurrentAddress.shared.address
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let userID = userID else { return }
        let paymentWaysInteractor = PaymentWaysInteractor()
        DispatchQueue.global(qos: .userInitiated).async {
            paymentWaysInteractor.loadPaymentData(userID: userID) { cards in
                var numbers = [String]()
                var images = [UIImage]()
                if !cards.isEmpty {
                    cards.forEach {
                        let lastFourDigits = "****" + $0.number.suffix(4)
                        numbers.append(lastFourDigits)
                        images.append(#imageLiteral(resourceName: "Visa"))
                    }
                    self.paymentWays.insert(contentsOf: numbers, at: 1)
                    self.paymentImages.insert(contentsOf: images, at: 1)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableViewHeightConstraint.constant += CGFloat(44 * numbers.count)
                        self.containerViewHeightConstraint.constant += CGFloat(44 * numbers.count)
                        UIView.animate(withDuration: 0.25) {
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                
            }
        }
        
    }
    
    //MARK: - Helper
    
    @objc
    private func closeVC(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            dismiss(animated: true)
        }
    }
}


//MARK: - UITableViewDataSourse

extension FoodOrderVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentWays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodOrderCell", for: indexPath)
        if let foodOrderCell = cell as? FoodOrderCell {
            foodOrderCell.leftImageView.image = paymentImages[indexPath.row]
            foodOrderCell.rightImageView.image = UIImage(named: "EmptyDot")
            foodOrderCell.paymentLabel.text = paymentWays[indexPath.row]
            if paymentWays.count != 2 && indexPath.row != 0 && indexPath.row != paymentWays.count - 1 {
                foodOrderCell.lastFourCardDigitsLabel.isHidden = false
                foodOrderCell.lastFourCardDigitsLabel.text = paymentWays[indexPath.row]
                foodOrderCell.paymentLabel.text = Localizable.FoodOrder.foodOrderCard.localized
            }
            if let selectedIndex = selectedIndex,selectedIndex == indexPath {
                foodOrderCell.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
            }
            return foodOrderCell
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension FoodOrderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        if indexPath.row == 0 { //наличные, нужно показать экран со сдачей
            paymentButton.setTitle(Localizable.FoodOrder.foodOrder.localized, for: .normal)
            containerViewHeightConstraint.constant += 50
        } else { // убрать экран со сдачей
            paymentButton.setTitle(Localizable.FoodOrder.foodOrderPay.localized, for: .normal)
            if selectedIndex?.row == 0 {
                containerViewHeightConstraint.constant -= 50
            }
        }
        selectedIndex = indexPath
        cashBackViewHeightConstraint.constant = indexPath.row == 0 ? 44 : 0
        cashbackView.isHidden = indexPath.row != 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - CashBackNeededViewDelegate

extension FoodOrderVC: CashBackNeededViewDelegate {
    
    func cashBackNeededViewClose() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0, options: .curveLinear) {
            self.cashBackNeededView.frame.origin.y = self.view.bounds.height
        } completion: { if $0 == .end {
            self.transparentView.isHidden = true
        }
            
        }

    }
    
    func cashBackNeededViewSpentLeftPrice() {
        cashbackValueLabel.isHidden = false
        cashbackValueLabel.text = Localizable.CashBack.cashBackLeftPrice.localized
        cashBackNeededViewClose()
    }
    
    func cashBackNeededViewSpentRightPrice() {
        cashbackValueLabel.isHidden = false
        cashbackValueLabel.text = Localizable.CashBack.cashBackRightPrice.localized
        cashBackNeededViewClose()
    }
    
    
    
    
}
