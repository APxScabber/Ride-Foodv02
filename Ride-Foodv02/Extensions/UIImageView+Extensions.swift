import UIKit

extension UIImageView {
    
    func roundedBy(_ value:CGFloat) {
        layer.cornerRadius = value
        clipsToBounds = true
    }
    
}
