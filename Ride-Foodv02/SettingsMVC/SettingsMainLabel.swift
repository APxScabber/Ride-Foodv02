import UIKit

class SettingsMainLabel: UILabel {

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        font = UIFont.SFUIDisplayRegular(size: 15)
        numberOfLines = 1
        minimumScaleFactor = 0.1
        adjustsFontSizeToFitWidth = true
    }

}
