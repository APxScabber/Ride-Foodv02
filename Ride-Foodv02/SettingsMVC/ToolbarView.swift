import UIKit

protocol ToolbarViewDelegate:AnyObject {
    func done()
    func remove()
}

//152 total height

class ToolbarView: UIView {
    
    //MARK: - API
    var state: ToolbarViewState = .undetected
    
    var text = "" { didSet { label?.text = self.text }}
    
    weak var delegate: ToolbarViewDelegate?
    
    //MARK: - Outlets
    
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

    @IBOutlet weak var swipeDoneView: RoundedView! { didSet {
        swipeDoneView.cornerRadius = 15.0
        swipeDoneView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    
    //MARK: - IBAction
    
    @IBAction func done(_ sender: UIButton) {
        delegate?.done()
    }


    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        button.setTitle(PersonalInfoConstant.confirm, for: .normal)
    }
    
    //MARK: - Helper
    
    @objc
    private func hideLabelIfNeeded() {
        label.isHidden = !(textField.text?.isEmpty ?? false)
        if state == .name {
            lineView.backgroundColor = label.isHidden ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
            button.isUserInteractionEnabled = label.isHidden
            roundedView.colorToFill = label.isHidden ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        } else if state == .email {
            lineView.backgroundColor = EmailChecker.validEmail(textField.text ?? "") ? #colorLiteral(red: 0.2392156863, green: 0.1921568627, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
            button.isUserInteractionEnabled = EmailChecker.validEmail(textField.text ?? "")
            roundedView.colorToFill = EmailChecker.validEmail(textField.text ?? "") ? #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1) : #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        }
        
    }
        
    
    func dismiss() {
        textField.resignFirstResponder()
        textField.text = nil
        hideLabelIfNeeded()
    }
    
    @objc
    private func remove(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.remove()
        }
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
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(remove(_:)))
        swipe.direction = .down
        addGestureRecognizer(swipe)
    }
    
    //MARK: - State
    
    enum ToolbarViewState {
        case undetected
        case name
        case email
    }
    
}


