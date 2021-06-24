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
    
}

extension UINib {
    
    func instantiate<T>() -> T {
        return instantiate(withOwner: nil, options: nil).first! as! T
    }
}
