import UIKit

class ShopListViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: - API
    var place = String()
    var address = String()
    var shops = [Shop]()
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var twoTopCornersRoundedView: UIView! { didSet {
        twoTopCornersRoundedView.layer.cornerRadius = 15.0
        twoTopCornersRoundedView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }}
    
    @IBOutlet weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        placeLabel.text = place
    }}
    @IBOutlet weak var addressLabel: UILabel! { didSet {
        addressLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
        addressLabel.text = address
    }}

    //MARK: - ViewController lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ShopFetcher.fetch { [weak self] in
            self?.shops = $0
            self?.collectionView.reloadData()
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
}
