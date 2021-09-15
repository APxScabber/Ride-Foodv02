import UIKit

class SwipeDownView: UIView {

    override func draw(_ rect: CGRect) {
        let fillPath = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5037558852).setFill()
        fillPath.fill()
    }

}
