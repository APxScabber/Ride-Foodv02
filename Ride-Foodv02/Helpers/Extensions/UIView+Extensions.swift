import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(self)", bundle: .main)
    }
    
    static func initFromNib() -> Self {
            func instanceFromNib<T: UIView>() -> T {
                return nib.instantiate()
            }
            return instanceFromNib()
        }
    

           public func addShadowToView(shadow_color: UIColor,offset: CGSize,shadow_radius: CGFloat,shadow_opacity: Float,corner_radius: CGFloat) {
               self.layer.shadowColor = shadow_color.cgColor
               self.layer.shadowOpacity = shadow_opacity
               self.layer.shadowOffset = offset
               self.layer.shadowRadius = shadow_radius
               self.layer.cornerRadius = corner_radius
           }
       
}

extension UINib {
    
    func instantiate<T>() -> T {
        return instantiate(withOwner: nil, options: nil).first! as! T
    }
}


