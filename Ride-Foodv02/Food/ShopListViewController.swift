import UIKit

protocol ShopListDelegate: AnyObject {
    func syncUI()
}

class ShopListViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    private var totalHeight: CGFloat = 140
    private var shouldIncreaseHeight = false
    weak var delegate: ShopListDelegate?
    
    var totalPriceInCart: Int = 0
    
    //MARK: - API
    var shops = [Shop]()
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomRoundedView: RoundedView! { didSet {
        bottomRoundedView.cornerRadius = 15.0
        bottomRoundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    
    @IBOutlet weak var shopNameLabel: UILabel! { didSet {
        shopNameLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var shopTotalPriceLabel: UILabel! { didSet {
        shopTotalPriceLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
    }}
    
    @IBOutlet weak var twoTopCornersRoundedView: TopRoundedView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var transparentView: UIView!
    
    @IBOutlet weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        placeLabel.text = CurrentAddress.shared.place
    }}
    @IBOutlet weak var addressLabel: UILabel! { didSet {
        addressLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
        addressLabel.text = CurrentAddress.shared.address
    }}
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint! { didSet {
        collectionViewHeightConstraint.constant = 0
    }}
    @IBOutlet weak var totalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRoundedViewHeightConstraint: NSLayoutConstraint!
    
    private var panGesture = UIPanGestureRecognizer()
    
    //MARK: - XIB
    
    private let orderRemoveView = OrderRemoveView.initFromNib()
    private let orderRemovedView = OrderRemovedView.initFromNib()
    
    //MARK: - Action
    
    @IBAction func removeCart(_ sender: UIButton) {
        showOrderRemoveView()
    }
    
    //MARK: - ViewController lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orderRemoveView.delegate = self
        orderRemoveView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 220.0)
        view.addSubview(orderRemoveView)
        
        orderRemovedView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 320)
        orderRemovedView.delegate = self
        view.addSubview(orderRemovedView)
        
        ShopFetcher.fetch { [weak self] in
            self?.shops = $0
            self?.collectionView.reloadData()
            self?.updateUI()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
         if !hasSetPointOrigin {
             hasSetPointOrigin = true
             pointOrigin = self.view.frame.origin
        
         }
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CurrentPrice.shared.reset()
    }
    
    //MARK: - CollectionViewDataSourse
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath)
        if let shopCell = cell as? ShopCollectionViewCell {
            shopCell.nameLabel.text = shops[indexPath.row].name
            shopCell.iconURL = shops[indexPath.row].iconURL
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 30.0)/2.0
        return CGSize(width: width, height: width/2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shop = shops[indexPath.item]
        if shop.id != CurrentShop.shared.id && CurrentShop.shared.total > 0 {
            showOrderRemoveView()
        } else {
            let storyboard = UIStoryboard(name: "Food", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "shopDetailVC") as! ShopDetailViewController
            vc.id = shop.id
            vc.shopName = shop.name
            vc.modalPresentationStyle = .custom
            vc.delegate = self
            vc.transitioningDelegate = self
            CurrentShop.shared.shop = shop.name
            CurrentShop.shared.id = shop.id
            if CurrentShop.shared.total == 0 { shouldIncreaseHeight = true }
            present(vc, animated: true)
        }
        
    }
    
    //MARK: - UI update
    
    private func updateUI() {
        let padding: CGFloat = 10.0
        let totalOffset: CGFloat = padding*3
        let rows = CGFloat((shops.count + 1)/2)
        let height = (view.bounds.width - totalOffset)/4.0*rows + padding*(rows+1)
        var offset: CGFloat = 0
        
        if CurrentShop.shared.total == 0 {
            bottomRoundedViewHeightConstraint.constant = 0
            offset = 50.0
        } else { showBottomView() }
        collectionViewHeightConstraint.constant = height
        totalHeightConstraint.constant += collectionViewHeightConstraint.constant - offset
        totalHeight = totalHeightConstraint.constant
        UIView.animate(withDuration: FoodConstants.durationForLiftingShopView) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] in
            if $0 {
                self?.spinner.stopAnimating()
            }
        }
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
              view.addGestureRecognizer(panGesture)
        
        
    }
    
    func showBottomView(){
        totalPriceInCart = 0
        FoodPersistanceManager.shared.fetchProductsInCart(shopID: CurrentShop.shared.id) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                data.forEach({ item in
                    self.totalPriceInCart += Int(item.price * item.qty)
                })
                if self.totalPriceInCart > 0{
                    self.updateBottomView(price: self.totalPriceInCart)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: view)
         guard translation.y >= 0 else { return }
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
         if sender.state == .ended {
             let dragVelocity = sender.velocity(in: view)
             if dragVelocity.y >= 1300 {
                 delegate?.syncUI()
                 dismiss(animated: true, completion: nil)
             } else {
                 UIView.animate(withDuration: 0.3) {
                     self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 300)
                 }
             }
         }
     }
    
    private func showOrderRemoveView() {
        panGesture.isEnabled = false
        orderRemoveView.show()
        transparentView.isHidden = false
    }
    
    
    private func checkIfUserHasActiveOrder() {
        showBottomView()
        if totalPriceInCart > 0 {
            if shouldIncreaseHeight {
                bottomRoundedViewHeightConstraint.constant = 50
                totalHeightConstraint.constant = totalHeight + 50
                shouldIncreaseHeight = false
            }
           
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            bottomRoundedViewHeightConstraint.constant = 0
            totalHeightConstraint.constant = totalHeight
            shouldIncreaseHeight = false
        }
    }
    
    private func updateBottomView(price: Int) {
        bottomRoundedView.isHidden = false
        shopNameLabel.text = "Магазин \(CurrentShop.shared.shop)"
        shopTotalPriceLabel.text = "\(price) \(Localizable.FoodOrder.foodOrderMoney.localized)"
    }
    
}

//MARK: - UIViewControllerTransitioningDelegate

extension ShopListViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, viewHeightMultiplierPercentage: 0.11)
    }
}

//MARK: - OrderRemoveDelegate

extension ShopListViewController: OrderRemoveViewDelegate {
    
    func orderRemoveViewClear() {
        FoodPersistanceManager.shared.deleteCoreDataInstance(shopID: CurrentShop.shared.id) { error in }
        CurrentShop.shared.reset()
        CurrentPrice.shared.reset()
        orderRemovedView.show()
    }
    
    func orderRemoveViewCancel() {
        transparentView.isHidden = true
        orderRemoveView.close()
        panGesture.isEnabled = true
    }
    
    
}

//MARK: - OrderRemovedViewDelegate

extension ShopListViewController: OrderRemovedViewDelegate {
    
    func returnToShopping() {
        orderRemoveView.close()
        transparentView.isHidden = true
        bottomRoundedViewHeightConstraint.constant = 0
        bottomRoundedView.isHidden = true
        totalHeightConstraint.constant -= 50
        panGesture.isEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - ShopListDelegate

extension ShopListViewController: ShopListDelegate {
    
    func syncUI() {
        checkIfUserHasActiveOrder()
    }
}
