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
        
        roundedView.addShadowToView(shadow_color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
                                         offset: CGSize(width: 0, height: 0),
                                         shadow_radius: 10,
                                         shadow_opacity: 1,
                                         corner_radius: 15)
        
    }}
    
    
    private func updateUI() {
        ImageFetcher.fetch(iconURL) { [weak self] in
            self?.shopImageView.image = UIImage(data: $0)
        }
            
        
    }
}
