import UIKit

class BackButton: UIButton {
    
    private let image = #imageLiteral(resourceName: "BackButton")
    private lazy var customImageView = UIImageView(image: image)
    
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: rect.center, radius: rect.width/2, startAngle: 0, endAngle: .pi*2, clockwise: false)
        UIColor.white.setFill()
        path.fill()
        
        customImageView.frame = CGRect(x: 14, y: 12, width: 10, height: 17)
        if customImageView.superview == nil { addSubview(customImageView) }
    }

}
