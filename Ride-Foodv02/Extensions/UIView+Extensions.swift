import UIKit


class RoundedView: UIView {
    
    var color: UIColor = .white { didSet { setNeedsDisplay() }}
    
    var cornerRadius: CGFloat = 15 { didSet { setNeedsDisplay() }}
        
        
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
        color.setStroke()
        path.stroke()
    }

}
