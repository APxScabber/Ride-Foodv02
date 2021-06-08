import UIKit

class RoundedButton: UIButton {

    var color = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) { didSet { setNeedsDisplay() }}
    
    var cornerRadius: CGFloat = 15 { didSet { setNeedsDisplay() }}
        
        
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        color.setFill()
        path.fill()
    }

}
