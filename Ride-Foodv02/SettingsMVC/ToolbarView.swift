import UIKit

protocol ToolbarViewDelegate:AnyObject {
    func done()
}

//152 total height
class ToolbarView: UIView {
    
    weak var delegate: ToolbarViewDelegate?
    
    @IBOutlet weak var textField:UITextField! { didSet {
        textField.addTarget(self, action: #selector(hideLabelIfNeeded), for: .editingChanged)
    }}
    
    @IBOutlet weak var label: UILabel! { didSet {
        label.font = UIFont.SFUIDisplayLight(size: 17)
    }}
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var button: UIButton! { didSet {
        button.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
    }}
    
    @IBOutlet private weak var activeView: UIView! { didSet {
        activeView.layer.cornerRadius = 15.0
        activeView.layer.backgroundColor = UIColor.white.cgColor
        activeView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }}
    
    @IBAction func done(_ sender: UIButton) {
        delegate?.done()
    }

    
    class func initFromNib() -> ToolbarView {
        return Bundle(for: ToolbarView.self).loadNibNamed(String(describing: "ToolbarView"), owner: nil, options: nil)!.first as! ToolbarView
    }
    
    @objc
    private func hideLabelIfNeeded() {
        label.isHidden = !(textField.text?.isEmpty ?? false)
        lineView.backgroundColor = label.isHidden ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        button.isUserInteractionEnabled = label.isHidden
        roundedView.colorToFill = label.isHidden ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) 
    }
    
}
