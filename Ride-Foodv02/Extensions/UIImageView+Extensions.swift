import UIKit

extension UIImageView {
    
    func roundedBy(_ value:CGFloat) {
        layer.masksToBounds = false
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = value
        clipsToBounds = true
    }
    
}
