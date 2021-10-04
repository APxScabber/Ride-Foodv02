import UIKit

@objc
protocol PromocodeToolbarDelegate: AnyObject {
    func activate(promocode:String)
    func closePromocodeToolbar()
}

//152 total height
class PromocodeToolbar: UIView, UITextFieldDelegate {
    
    //MARK: - API
    weak var delegate: PromocodeToolbarDelegate?
    private var promocodeEntered: Bool { textField.text?.count == 8 }
    private var shouldHideErrorLabel = false
    
    //MARK: - Outlets
    @IBOutlet weak var textField:UITextField! { didSet {
        textField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        textField.delegate = self
    }}

    @IBOutlet weak var errorLabel: UILabel! { didSet {
        errorLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
        errorLabel.text = ""
    }}
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var button: UIButton! { didSet {
        button.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 15.0
    }}
    
    
    @IBOutlet weak var heightConstraint:NSLayoutConstraint! { didSet {
        heightConstraint.constant = CGFloat(145.0 + SafeArea.shared.bottom)
    }}
    
    //MARK: - Action
    @IBAction func done(_ sender: UIButton) {
        guard let code = textField.text else { return }
        delegate?.activate(promocode: code)
    }

    //MARK: - UI change
    
    @objc
    private func updateState() {
        errorLabel.isHidden = shouldHideErrorLabel
        lineView.backgroundColor = promocodeEntered ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        button.isUserInteractionEnabled = promocodeEntered
        button.backgroundColor = promocodeEntered ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        shouldHideErrorLabel = true
    }
    
    func showErrorWith(_ text:String) {
        lineView.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        errorLabel.text = text
        spinner.stopAnimating()
        shouldHideErrorLabel = false
        updateState()
    }
    
    //MARK: - Textfield delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count == 2 && string == "" { return false }
        if text.count == 8 && string != "" { return false}
        return true
    }
    
    //MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        button.setTitle(Localizable.PersonalInfo.confirm.localized, for: .normal)
    }
    
    //MARK: - Init
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
    
    //MARK: - Dismiss
    
    func dismiss() {
        textField.resignFirstResponder()
        textField.text = nil
        removeFromSuperview()
        updateState()
        errorLabel.text = ""
    }
    @objc
    private func close(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            textField.resignFirstResponder()
            spinner.stopAnimating()
            textField.text = "R-"
            errorLabel.text = ""
            updateState()
            delegate?.closePromocodeToolbar()
        }
    }
}


