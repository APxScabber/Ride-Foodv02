import UIKit

protocol PromocodeToolbarDelegate: AnyObject {
    func activate(promocode:String)
}

//152 total height
class PromocodeToolbar: UIView, UITextFieldDelegate {
    
    weak var delegate: PromocodeToolbarDelegate?
    
    @IBOutlet weak var textField:UITextField! { didSet {
        textField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        textField.delegate = self
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
        guard let code = textField.text else { return }
        delegate?.activate(promocode: code)
    }

    private var promocodeEntered: Bool { textField.text?.count == 8 }
    
    
    @objc
    private func updateState() {
        lineView.backgroundColor = promocodeEntered ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        button.isUserInteractionEnabled = promocodeEntered
        roundedView.colorToFill = promocodeEntered ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }
    
    func dismiss() {
        textField.resignFirstResponder()
        textField.text = nil
        removeFromSuperview()
        updateState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count == 2 && string == "" { return false }
        if text.count == 8 && string != "" { return false}
        return true
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.setTitle(PersonalInfoConstant.confirm, for: .normal)
    }
    
    
}


