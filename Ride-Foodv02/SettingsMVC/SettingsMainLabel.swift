import UIKit

class SettingsMainLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        font = UIFont.SFUIDisplayRegular(size: 15)
        numberOfLines = 1
        minimumScaleFactor = 0.1
    }

}
