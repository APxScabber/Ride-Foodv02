import UIKit

@objc
protocol PromocodeToolbarDelegate: AnyObject {
    func activate(promocode:String)
    @objc optional func closePromocodeToolbar()
}

//152 total height
class PromocodeToolbar: UIView, UITextFieldDelegate {
    
    weak var delegate: PromocodeToolbarDelegate?
    
    @IBOutlet weak var textField:UITextField! { didSet {
        textField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        textField.delegate = self
    }}

    @IBOutlet weak var errorLabel: UILabel! { didSet {
        errorLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 15.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var button: UIButton! { didSet {
        button.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        button.isUserInteractionEnabled = false
    }}
    
    @IBOutlet private weak var activeView: UIView! { didSet {
        activeView.layer.cornerRadius = 15.0
        activeView.layer.backgroundColor = UIColor.white.cgColor
        activeView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }}
    
    @IBOutlet weak var heightConstraint:NSLayoutConstraint! { didSet {
        heightConstraint.constant = CGFloat(145.0 + SafeArea.shared.bottom)
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
        errorLabel.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count == 2 && string == "" { return false }
        if text.count == 8 && string != "" { return false}
        return true
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.setTitle(Localizable.PersonalInfo.confirm.localized, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(close(_:)))
        swipe.direction = .down
        addGestureRecognizer(swipe)
    }
    
    @objc
    private func close(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            textField.resignFirstResponder()
            spinner.stopAnimating()
            textField.text = "R-"
            updateState()
            delegate?.closePromocodeToolbar?()
        }
    }
}


