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
    
   
    @IBOutlet weak var addPhoneButton: UIButton! { didSet {
        addPhoneButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        addPhoneButton.layer.cornerRadius = 15.0
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
    
    //MARK: - Close
    @objc
    private func close(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.addPhoneViewClose()
        }
    }
    
    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let addButtonText = state == .add_Change ? Localizable.Phones.phoneAdd.localized : Localizable.Phones.phoneSetToMain.localized
        let changeButtonText = state == .add_Change ? Localizable.Phones.phoneChange.localized : Localizable.Phones.phoneRemove.localized
        addPhoneButton.setTitle(addButtonText, for: .normal)
        changePhoneButton.setTitle(changeButtonText, for: .normal)
    }
    
    //MARK: - State 
    enum AddPhoneViewState {
        case add_Change
        case setToMain_Delete
    }
}
