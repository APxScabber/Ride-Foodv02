import UIKit

protocol PhoneChooserViewDelegate: AnyObject {
    func dismiss()
    func add()
}

class PhoneChooserView: UIView {

    //MARK: - API
    
    weak var delegate: PhoneChooserViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var buttonRoundedView: RoundedView! { didSet {
        buttonRoundedView.cornerRadius = 15.0
        buttonRoundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    @IBOutlet weak var topCornerView: TopRoundedView!
    
    @IBOutlet weak var addPhoneButton: UIButton! { didSet {
        addPhoneButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        addPhoneButton.setTitle(ProfileConstant.addPhone, for: .normal)
    }}
    
    @IBOutlet weak var changePhoneButton: UIButton! { didSet {
        changePhoneButton.titleLabel?.font = UIFont.SFUIDisplayLight(size: 17.0)
        changePhoneButton.setTitle(ProfileConstant.changePhone, for: .normal)
    }}
    
    //MARK: - Actions
    
    @IBAction func addPhone(_ sender: UIButton) {
        delegate?.add()
    }
    
    @IBAction func changePhone(_ sender: UIButton) {
        
    }
    
    private func close() {
        
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
    
    //MARK: - Gesture
    
    @objc
    private func removeFromVC(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.dismiss()
        }
    }
    
}
