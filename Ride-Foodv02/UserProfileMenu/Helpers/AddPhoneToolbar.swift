import UIKit

protocol AddPhoneToolbarDelegate: AnyObject {
    func addPhoneToolbarClose()
    func addPhoneToolbarAdd(_ phone:String)
    func addPhoneToolbarChange(_ phone:String,at index:Int)
}

class AddPhoneToolbar: UIView, UITextFieldDelegate {

    //MARK: - API
    
    var index = 0
    var state: AddPhoneState = .add
    weak var delegate: AddPhoneToolbarDelegate?
    private var phoneEntered: Bool { textField.text?.count == 18 }
    
    //MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField! { didSet {
        textField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        textField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        textField.delegate = self
        textField.text = "+7"
    }}

    @IBOutlet weak var underbarLine: UIView!
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        confirmButton.setTitle(Localizable.Promocode.confirm.localized, for: .normal)
    }}
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
 
    //MARK: - Action
    
    @IBAction func confirm(_ sender: UIButton) {
        if state == .add {
            delegate?.addPhoneToolbarAdd(textField.text ?? "")
        } else {
            delegate?.addPhoneToolbarChange(textField.text ?? "", at: index)
        }
    }
    
    //MARK: - Logic
    
    @objc
    private func updateState() {
        underbarLine.backgroundColor = phoneEntered ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        confirmButton.isUserInteractionEnabled = phoneEntered
        roundedView.colorToFill = phoneEntered ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        let formatedNumber = textField.text!.applyPatternOnNumbers(pattern:
                                    LoginConstantText.phoneFormatFull.rawValue,
                                   replacmentCharacter: "#")
        textField.text = formatedNumber
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count == 2 && string == "" { return false }
        if text.count == 18 && string != "" { return false}
        return true
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
    
    @objc
    private func close(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.addPhoneToolbarClose()
        }
    }
    
    //MARK: - Enum
    enum AddPhoneState {
        case changed
        case add
    }
}
