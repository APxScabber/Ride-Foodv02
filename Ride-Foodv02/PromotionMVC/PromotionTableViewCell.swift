import UIKit

class PromotionTableViewCell: UITableViewCell {

    //MARK: -  API
    var resignationHandler: ( () -> () )?
    
    //MARK: - Outlets
    
    @IBOutlet weak var background: UIImageView! 
    @IBOutlet weak var promotionLabel: UILabel! { didSet {
        promotionLabel.font = UIFont.SFUIDisplayBold(size: 20)
    }}
    
    @IBOutlet weak var detailsButton: UIButton! { didSet {
        detailsButton.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
        detailsButton.setTitle(Localizable.Promotion.more.localized, for: .normal)
    }}
    @IBOutlet weak private var roundedView: RoundedView! { didSet {
        roundedView.colorToFill = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3046511214)
        roundedView.cornerRadius = 8.0
    }}
    
    //MARK: - Logic
    
    func fetchImageFrom(_ str:String) {
        ImageFetcher.fetch(str) { [weak self] data in
            self?.background.image = UIImage(data: data)
            self?.background.layer.cornerRadius = 15.0
        }
    }
    
    @objc
    private func buttonTouched() {
        resignationHandler?()
    }
    
}
