import UIKit

protocol EnterPhoneViewDelegate: AnyObject {
    func add(_ newPhone: String)
    func change(_ newPhone: String)
    func close()
}

class EnterPhoneView: UIView, UITextFieldDelegate {

    
    //MARK: - API
    
    weak var delegate: EnterPhoneViewDelegate?
    
   //MARK: - Outlets
    
    @IBOutlet weak var textField:UITextField! { didSet {
        textField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        textField.delegate = self
    }}

    
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
    }}
    
    @IBOutlet private weak var activeView: TopRoundedView!

    //MARK: - Actions
    
    @IBAction func addPhone(_ sender: UIButton) {
        delegate?.add(textField.text ?? "")
    }
    
    @IBAction func changePhone(_ sender: UIButton) {
        delegate?.change(textField.text ?? "")
    }
    
    //MARK: - Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count == 3 && string == "" { return false }
        if text.count == 18 && string != "" { return false }
        textField.text = textField.text!.applyPatternOnNumbers(pattern: "+# (###) ###-##-##", replacmentCharacter: "#")
        return true
    }
    
    //MARK: - UI update
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.setTitle(ProfileConstant.confirm, for: .normal)
    }
    private var phoneEntered: Bool { textField.text?.count == 18 }
    @objc
    private func updateState() {
        lineView.backgroundColor = phoneEntered ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        button.isUserInteractionEnabled = phoneEntered
        roundedView.colorToFill = phoneEntered ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
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
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(removeFromVC(_:)))
        swipe.direction = .down
        addGestureRecognizer(swipe)
    }
    
    @objc
    private func removeFromVC(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.close()
        }
    }
}

