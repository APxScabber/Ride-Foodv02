import UIKit

class PromocodeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! { didSet {
        titleLabel.font = UIFont.SFUIDisplayRegular(size: 12)
    }}
    
    @IBOutlet weak var descriptionLabel: UILabel! { didSet {
        descriptionLabel.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel! { didSet {
        statusLabel.font = UIFont.SFUIDisplayLight(size: 12)
    }}
    
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topView.layer.cornerRadius = 15.0
        topView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = 15.0
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
}
