import UIKit

class ShopDetailViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    //MARK: - API
    
    var id = 0
    var shopName = String()
    var shopDetail:ShopDetail!
    
    //MARK: - Outlets
    @IBOutlet weak var shopNameLabel: UILabel! { didSet {
        shopNameLabel.font = UIFont.SFUIDisplaySemibold(size: 15.0)
        shopNameLabel.text = "Магазин " + shopName.lowercased()
    }}
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoTopCornersRoundedView: UIView! { didSet {
        twoTopCornersRoundedView.layer.cornerRadius = 15.0
        twoTopCornersRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }}
    
    @IBOutlet weak var showDetailButton: UIButton! { didSet {
        showDetailButton.isUserInteractionEnabled = false
    }}
    
    private let shopDetailView = ShopDetailView.initFromNib()
    
    //MARK: - IBActions
    
    @IBAction func close(_ sender: UIButton) {
        
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        shopDetailView.isHidden = false
        showDetailButton.isUserInteractionEnabled = false
        view.subviews.filter { !$0.isKind(of: ShopDetailView.self)}.forEach { $0.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
        collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: FoodConstants.durationForLiftingShopDetailView, delay: 0, options: .curveLinear) {
            self.shopDetailView.frame.origin.y -= (FoodConstants.shopDetailViewHeight + self.bottomSafeAreaConstant)
        } completion: { if $0 == .end {}
            
        }

    }
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        shopDetailView.delegate = self
        shopDetailView.isHidden = true
        view.addSubview(shopDetailView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shopDetailView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: FoodConstants.shopDetailViewHeight + bottomSafeAreaConstant)
        ShopDetailFetcher.fetch(shopID: id) { [weak self] in
            self?.shopDetail = $0
            self?.updateShopDetailView()
            self?.showDetailButton.isUserInteractionEnabled = true
            self?.collectionView.reloadData()
        }
    }
    
    private var bottomSafeAreaConstant: CGFloat = 0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomSafeAreaConstant = view.safeAreaInsets.bottom
    }
    //MARK: - CollectionViewDatasourse
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopDetail?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopDetailCell", for: indexPath)
        if let shopDetailCell = cell as? ShopDetailCollectionViewCell {
            shopDetailCell.categoryLabel.text = shopDetail.categories[indexPath.item].name
            shopDetailCell.iconURL = shopDetail.categories[indexPath.item].iconURL
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 60)/2
        return CGSize(width: width, height: width*0.75)
    }
    
    //MARK: - UI changes
    
    private func updateShopDetailView() {
        guard let shopDetail = shopDetail else { return }
        shopDetailView.titleLabel.text = shopNameLabel.text
        shopDetailView.addressLabel.text = shopDetail.address
        shopDetailView.scheduleLabel.text = shopDetail.schedule
        shopDetailView.descriptionLabel.text = shopDetail.description
    }
}

//MARK: - ShopDetailViewDelegate

extension ShopDetailViewController: ShopDetailViewDelegate {
    
    func close() {
        view.subviews.filter { !$0.isKind(of: ShopDetailView.self)}.forEach { $0.backgroundColor = .white }
        collectionView.backgroundColor = .white
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: FoodConstants.durationForLiftingShopDetailView, delay: 0, options: .curveLinear) {
            self.shopDetailView.frame.origin.y += FoodConstants.shopDetailViewHeight + self.bottomSafeAreaConstant
        } completion: { if $0 == .end {
            self.showDetailButton.isUserInteractionEnabled = true
        }
            
        }
    }
}
