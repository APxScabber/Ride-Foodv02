import UIKit

protocol PhoneConfirmViewDelegate: AnyObject {
    func phoneConfirmViewAdd(_ phone: String)
}

class PhoneConfirmView: UIView, UITextFieldDelegate {

    var seconds = 30
    var phone = String()
    weak var timer: Timer?
    weak var delegate: PhoneConfirmViewDelegate?
    
    private let loginInteractor = LoginInteractor()
    
    @IBOutlet weak var textField: UITextField! { didSet {
        textField.delegate = self
        textField.addTarget(self, action: #selector(updateConfirmViews), for: .editingChanged)
    }}
    @IBOutlet var confirmViews: [ConfirmView]!
    
    @IBOutlet weak var confirmationLabel: UILabel! { didSet {
        confirmationLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var sendMessageLabel: UILabel! { didSet {
        sendMessageLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
        sendMessageLabel.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.553, alpha: 1)
    }}
    
    @IBOutlet weak var resendLabel: UILabel! { didSet {
        resendLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
        resendLabel.textColor = UIColor(red: 0.541, green: 0.541, blue: 0.553, alpha: 1)
        resendLabel.text = Localizable.Phones.phoneResend.localized
    }}
    
    @IBOutlet weak var errorLabel: UILabel! { didSet {
        errorLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
        errorLabel.text = Localizable.Phones.phoneErrorConfirm.localized
    }}
    
    @IBOutlet weak var secondsLabel: UILabel! { didSet {
        secondsLabel.font = UIFont.SFUIDisplayRegular(size: 10)
    }}
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @objc private func updateView() {
        if seconds == 0 {
            loginInteractor.reciveConfirmCode(from: phone)
            seconds = 30
        }
        seconds -= 1
        secondsLabel.text = "\(seconds) секунд" + (additionalLetterToSeconds[seconds] ?? "")
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
        loginInteractor.reciveConfirmCode(from: phone)
        textField.becomeFirstResponder()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if text.count == 4 && string != "" { return false }
        return true
    }
    
    @objc
    private func updateConfirmViews() {
        guard let text = textField.text else { return }
        errorLabel.isHidden = true
        confirmViews.forEach { $0.state = .hasEmptyDot }
        for i in 0..<text.count {
            confirmViews[i].state = .hasDigit
            confirmViews[i].textLabel.text = text[i]
        }
        if text.count == 4 {
            if text == ConfirmationCode.shared.current {
                reset()
            } else {
                errorLabel.isHidden = false
            }
        }
    }
    
    private func reset() {
        timer?.invalidate()
        confirmViews.forEach { $0.state = .hasEmptyDot }
        textField.text = ""
        delegate?.phoneConfirmViewAdd(phone)
        seconds = 30
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sendMessageLabel.text = "\(Localizable.Phones.phoneToNumber.localized) \(phone) \(Localizable.Phones.phoneSendCode.localized)"
        confirmationLabel.text = Localizable.Phones.phoneConfirm.localized
    }
    
    private let additionalLetterToSeconds: [Int:String] = [
        1:"y",2:"ы",3:"ы",4:"ы",21:"y",22:"ы",23:"ы",24:"ы"
    ]
    
}


class ConfirmView: UIView {
    
    var textLabel = UILabel()
    var emptyDotView = EmptyDotView()
    
    var state: ConfirmViewState = .hasEmptyDot { didSet { updateUI() }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 4.0
        textLabel.font = UIFont.SFUIDisplayLight(size: 17.0)
        textLabel.textAlignment = .center
        textLabel.frame = bounds
        textLabel.textColor = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        addSubview(textLabel)
        emptyDotView.frame = CGRect(x: 13, y: 13, width: 10, height: 10)
        emptyDotView.backgroundColor = .clear
        addSubview(emptyDotView)
        updateUI()
    }
    
    private func updateUI() {
        emptyDotView.isHidden = state == .hasDigit
        textLabel.isHidden = state == .hasEmptyDot
    }
    
    enum ConfirmViewState {
        case hasDigit
        case hasEmptyDot
    }
    
}

class EmptyDotView: UIView {
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(arcCenter: rect.center, radius: rect.width/2, startAngle: 0, endAngle: .pi*2, clockwise: true)
        #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1).setFill()
        circlePath.fill()
    }
    
}


