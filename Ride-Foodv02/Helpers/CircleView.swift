import UIKit

class CircleView: UIView {

    var color: UIColor = .white { didSet { setNeedsDisplay() }}
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: rect.center, radius: rect.width/2, startAngle: 0, endAngle: .pi*2, clockwise: false)
        color.setFill()
        path.fill()
    }

}
