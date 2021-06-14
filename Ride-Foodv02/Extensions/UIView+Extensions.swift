import UIKit


class RoundedView: UIView {
    
    var color: UIColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) { didSet { setNeedsDisplay() }}
    
    var cornerRadius: CGFloat = 15 { didSet { setNeedsDisplay() }}
    
    var colorToFill: UIColor = .white { didSet { setNeedsDisplay() }}
        
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
        color.setStroke()
        path.stroke()
        
        let fillPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        colorToFill.setFill()
        fillPath.fill()
        
    }

}
