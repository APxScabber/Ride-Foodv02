import UIKit

class ShopDetailViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

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
        topRoundedView.colorToFill = UIColor.lightGray
    }}
    @IBOutlet weak var twoTopCornersRoundedView: TopRoundedView!
    @IBOutlet weak var showDetailButton: UIButton! { didSet {
        showDetailButton.isUserInteractionEnabled = false
    }}
    @IBOutlet weak var backButton: UIButton!
    
    private let shopDetailView = ShopDetailView.initFromNib()
    
    //MARK: - IBActions
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        shopDetailView.isHidden = false
        showDetailButton.isUserInteractionEnabled = false
        backButton.isUserInteractionEnabled = false
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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
              view.addGestureRecognizer(panGesture)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
         if !hasSetPointOrigin {
             hasSetPointOrigin = true
             pointOrigin = self.view.frame.origin
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = shopDetail.categories[indexPath.item]
        let storyboard = UIStoryboard(name: "Food", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubCategoriesVC") as! CategoriesAndFoodVC
        vc.shopName = shopDetail.name
        vc.mainCategoryName = item.name
        vc.shopID = shopDetail.id
        vc.CategoryID = item.id
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        
        
        self.present(vc, animated: true)
    }
    
    //MARK: - UI changes
    
    private func updateShopDetailView() {
        guard let shopDetail = shopDetail else { return }
        shopDetailView.titleLabel.text = shopNameLabel.text
        shopDetailView.addressLabel.text = shopDetail.address
        shopDetailView.scheduleLabel.text = shopDetail.schedule
        shopDetailView.descriptionLabel.text = shopDetail.description
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: view)

         // Not allowing the user to drag the view upward
         guard translation.y >= 0 else { return }

         // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)

         if sender.state == .ended {
             let dragVelocity = sender.velocity(in: view)
             if dragVelocity.y >= 1300 {
                 // Velocity fast enough to dismiss the uiview
                 self.dismiss(animated: true, completion: nil)
             } else {
                 // Set back to original position of the view controller
                 UIView.animate(withDuration: 0.3) {
                     self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 300)
                 }
             }
         }
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
            self.backButton.isUserInteractionEnabled = true
        }
            
        }
    }
}

extension ShopDetailViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, viewHeightMultiplierPercentage: 0.11)
    }
}
