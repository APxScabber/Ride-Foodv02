import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView! { didSet {
        updateUI()
    }}
    
    @IBOutlet weak var label: UILabel! { didSet {
        label.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    @IBOutlet weak var mainLabel: UILabel! { didSet {
        mainLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        mainLabel.text = ProfileConstant.main
    }}
    
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func updateUI() {
        labelLeadingConstraint?.constant = customImageView.image == nil ? 0 : 25.0
    }
}
