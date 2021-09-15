import UIKit

class ShadowRoundedView: RoundedView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        colorToFill = .white
        cornerRadius = 15.0
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.09810299905).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }

}
