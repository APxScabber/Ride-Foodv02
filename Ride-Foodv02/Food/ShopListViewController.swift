import UIKit

class ShopListViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    //MARK: - API
    var place = String()
    var address = String()
    var shops = [Shop]()
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = UIColor.lightGray
    }}
    @IBOutlet weak var twoTopCornersRoundedView: TopRoundedView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        placeLabel.text = place
    }}
    @IBOutlet weak var addressLabel: UILabel! { didSet {
        addressLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
        addressLabel.text = address
    }}
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - ViewController lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let storyboard = UIStoryboard(name: "Food", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "shopDetailVC") as! ShopDetailViewController
        vc.id = shop.id
        vc.shopName = shop.name
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        
        
        self.present(vc, animated: true)
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopDetail",
           let destination = segue.destination as? ShopDetailViewController,
           let cell = sender as? ShopCollectionViewCell,
           let indexPath = collectionView.indexPath(for: cell) {
                destination.id = shops[indexPath.item].id
                destination.shopName = shops[indexPath.item].name
        }
    }
    
    //MARK: - UI update
    
    private func updateUI() {
        let padding: CGFloat = 10.0
        let totalOffset: CGFloat = padding*3
        let rows = CGFloat((shops.count + 1)/2)
        let height = (view.bounds.width - totalOffset)/4.0*rows + padding*(rows+1)
        
        collectionViewHeightConstraint.constant = height + CGFloat(SafeArea.shared.bottom)
        
        UIView.animate(withDuration: FoodConstants.durationForLiftingShopView) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] in
            if $0 {
                self?.spinner.stopAnimating()
            }
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
              view.addGestureRecognizer(panGesture)
        
        
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
extension ShopListViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, viewHeightMultiplierPercentage: 0.11)
    }
}
