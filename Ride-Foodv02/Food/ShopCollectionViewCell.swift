import UIKit

class ShopCollectionViewCell: UICollectionViewCell {

    var iconURL:String = "" { didSet { updateUI() }}
    
    @IBOutlet weak var nameLabel: UILabel! { didSet {
        nameLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var shopImageView: UIImageView!
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = .white
    }}
    
    
    private func updateUI() {
        ImageFetcher.fetch(iconURL) { [weak self] in
            self?.shopImageView.image = UIImage(data: $0)
        }
            
        
    }
}
