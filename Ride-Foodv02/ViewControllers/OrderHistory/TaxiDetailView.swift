import UIKit

class TaxiDetailView: RoundedView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    
    private func setup() {
        cornerRadius = 15.0
        colorToFill = .white
    }
}
