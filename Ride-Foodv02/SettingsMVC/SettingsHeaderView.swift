import UIKit

class SettingsHeaderView {
    
    static func createWith(_ text:String, in view:UIView) -> UIView {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        let label = UILabel(frame: CGRect(x: 25, y: 0, width: view.bounds.width - 25, height: 14))
        var attributes = [NSAttributedString.Key:Any]()
        attributes[.font] = UIFont.SFUIDisplayRegular(size:12)
        attributes[.foregroundColor] = UIColor.SettingsHeaderColor
        let attString = NSAttributedString(string: text,attributes: attributes)
        label.attributedText = attString
        customView.addSubview(label)
        return customView
    }
    
}
