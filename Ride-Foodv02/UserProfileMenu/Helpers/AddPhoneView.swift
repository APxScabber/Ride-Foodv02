import UIKit

protocol AddPhoneViewDelegate: AnyObject {
    func addPhoneViewAdd()
    func addPhoneViewChange()
    func addPhoneViewClose()
    func addPhoneRemove()
    func addPhoneSetToMain()
}

class AddPhoneView: UIView {

    //MARK: - API
    
    weak var delegate: AddPhoneViewDelegate?
    var index = 0
    var state: AddPhoneViewState = .add_Change
    
    //MARK: - Outlets
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
   
    @IBOutlet weak var addPhoneButton: UIButton! { didSet {
        addPhoneButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var changePhoneButton: UIButton! { didSet {
        changePhoneButton.titleLabel?.font = UIFont.SFUIDisplayLight(size: 17.0)
    }}
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //MARK: - Actions
    
    @IBAction func addPhone(_ sender: UIButton) {
        if state == .add_Change {
            delegate?.addPhoneViewAdd()
        } else {
            delegate?.addPhoneSetToMain()
        }
    }
    
    @IBAction func changePhone(_ sender: UIButton) {
        if state == .add_Change {
            delegate?.addPhoneViewChange()
        } else {
            delegate?.addPhoneRemove()
        }
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
    private func close(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.addPhoneViewClose()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let addButtonText = state == .add_Change ? Localizable.Phones.phoneAdd.localized : Localizable.Phones.phoneSetToMain.localized
        let changeButtonText = state == .add_Change ? Localizable.Phones.phoneChange.localized : Localizable.Phones.phoneRemove.localized
        addPhoneButton.setTitle(addButtonText, for: .normal)
        changePhoneButton.setTitle(changeButtonText, for: .normal)
    }
    
    enum AddPhoneViewState {
        case add_Change
        case setToMain_Delete
    }
}
