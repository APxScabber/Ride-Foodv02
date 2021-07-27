import UIKit

class ShopDetailCollectionViewCell: UICollectionViewCell {

    var iconURL = "" { didSet { updateUI() }}
    
    @IBOutlet weak var categoryLabel: UILabel! { didSet {
    }}
    
    @IBOutlet weak var imageView: UIImageView! { didSet {
        layer.cornerRadius = 15.0
    }}
    
    private func updateUI() {
        ImageFetcher.fetch(iconURL) { [weak self] in
            self?.imageView.image = UIImage(data: $0)
        }
    }
    
}
