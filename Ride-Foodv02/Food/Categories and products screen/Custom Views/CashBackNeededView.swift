import UIKit

protocol CashBackNeededViewDelegate: AnyObject {
    func cashBackNeededViewClose()
    func cashBackNeededViewSpentLeftPrice()
    func cashBackNeededViewSpentRightPrice()

}

class CashBackNeededView: UIView {

    //MARK: - API
    weak var delegate: CashBackNeededViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel! { didSet {
        titleLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        titleLabel.text = Localizable.CashBack.cashBackTitle.localized
    }}
    
    @IBOutlet weak var leftRoundedView: RoundedView! { didSet {
        leftRoundedView.cornerRadius = 15.0
        leftRoundedView.colorToFill = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
    }}
    
    @IBOutlet weak var leftPriceLabel: UILabel! { didSet {
        leftPriceLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        leftPriceLabel.text = Localizable.CashBack.cashBackLeftPrice.localized
    }}

    @IBOutlet weak var rightRoundedView: RoundedView! { didSet {
        rightRoundedView.cornerRadius = 15.0
        rightRoundedView.colorToFill = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
    }}
    
    @IBOutlet weak var rightPriceLabel: UILabel! { didSet {
        rightPriceLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        rightPriceLabel.text = Localizable.CashBack.cashBackRightPrice.localized
    }}
    
    //MARK: - Actions
    
    @IBAction func leftButtonChoosen(_ sender: UIButton) {
        delegate?.cashBackNeededViewSpentLeftPrice()
    }
    
    @IBAction func rightButtonChoosen(_ sender: UIButton) {
        delegate?.cashBackNeededViewSpentRightPrice()
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
            delegate?.cashBackNeededViewClose()
        }
    }
}
