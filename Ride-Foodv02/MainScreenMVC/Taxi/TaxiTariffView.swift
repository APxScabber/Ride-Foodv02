import UIKit

protocol TaxiTariffViewDelegate: AnyObject {
    func tariffEntered(index: Int)
}

class TaxiTariffView: UIView {

    //MARK: - API
    weak var delegate: TaxiTariffViewDelegate?
    
    var selectedIndex: Int?
    var scoresEntered = 0 { didSet { recreateViewIfNeeded() }}
    
    private let prices = [100,250,430]
    
    //MARK: - Outlets
    
    @IBOutlet weak var standartRoundedView: ShadowRoundedView! { didSet {
        standartRoundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectStandartView(_:))))
    }}
    @IBOutlet weak var standartLabel: UILabel! { didSet {
        standartLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var standartPriceLabel: UILabel! { didSet {
        standartPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        standartPriceLabel.text = "\(prices[0]) руб"
    }}
    @IBOutlet weak var standartDurationLabel: UILabel! { didSet {
        standartDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    @IBOutlet weak var standartOldPriceLabel: UILabel! { didSet {
        standartOldPriceLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var standartImageView: UIImageView!
    
    @IBOutlet weak var premiumRoundedView: ShadowRoundedView! { didSet {
        premiumRoundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPremiumView(_:))))
    }}
    
    @IBOutlet weak var premiumLabel: UILabel! { didSet {
        premiumLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var premiumPriceLabel: UILabel! { didSet {
        premiumPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        premiumPriceLabel.text = "\(prices[1]) руб"
    }}
    @IBOutlet weak var premiumDurationLabel: UILabel! { didSet {
        premiumDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    @IBOutlet weak var premiumOldPriceLabel: UILabel! { didSet {
        premiumOldPriceLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var premiumImageView: UIImageView!

    @IBOutlet weak var businessRoundedView: ShadowRoundedView! { didSet {
        businessRoundedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectBusinessView(_:))))
    }}
    @IBOutlet weak var businessLabel: UILabel! { didSet {
        businessLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var businessPriceLabel: UILabel! { didSet {
        businessPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        businessPriceLabel.text = "\(prices[2]) руб"
    }}
    @IBOutlet weak var businessDurationLabel: UILabel! { didSet {
        businessDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    @IBOutlet weak var businessOldPriceLabel: UILabel! { didSet {
        businessOldPriceLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    @IBOutlet weak var businessImageView: UIImageView!

    //MARK: - Setup

    @objc
    private func selectStandartView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended  {
            reset()
            selectedIndex = 0
            updateStandartView()
            delegate?.tariffEntered(index: selectedIndex ?? 0)
        }
    }
    
    private func updateStandartView() {
        standartRoundedView.colorToFill = .white
        standartImageView.image = #imageLiteral(resourceName: "StandartCar")
        standartDurationLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        standartPriceLabel.textColor = .black
        if scoresEntered != 0 {
            update(oldLabel: standartOldPriceLabel, label: standartPriceLabel, oldPrice: prices[0], price: prices[0] - scoresEntered)
        }
    }
    
    @objc
    private func selectPremiumView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended  {
            reset()
            selectedIndex = 1
            updatePremiumView()
            delegate?.tariffEntered(index: selectedIndex ?? 1)
        }
    }
    
    private func updatePremiumView() {
        premiumRoundedView.colorToFill = .white
        premiumImageView.image = #imageLiteral(resourceName: "PremiumCar")
        premiumDurationLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.2588235294, blue: 0.9490196078, alpha: 1)
        premiumPriceLabel.textColor = .black
        if scoresEntered != 0 {
            update(oldLabel: premiumOldPriceLabel, label: premiumPriceLabel, oldPrice: prices[1], price: prices[1] - scoresEntered)
        }
    }
    
    
    @objc
    private func selectBusinessView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended  {
            reset()
            selectedIndex = 2
            updateBusinessView()
            delegate?.tariffEntered(index: selectedIndex ?? 2)
        }
    }
    
    private func updateBusinessView() {
        businessRoundedView.colorToFill = .white
        businessImageView.image = #imageLiteral(resourceName: "BusinessCar")
        businessDurationLabel.textColor = #colorLiteral(red: 0.831372549, green: 0.7411764706, blue: 0.5019607843, alpha: 1)
        businessPriceLabel.textColor = .black
        if scoresEntered != 0 {
            update(oldLabel: businessOldPriceLabel, label: businessPriceLabel, oldPrice: prices[2], price: prices[2] - scoresEntered)
        }
    }
    
    func reset() {

        frame.size.height = 155
        selectedIndex = nil
        standartRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        premiumRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        businessRoundedView.colorToFill = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        
        standartDurationLabel.textColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        premiumDurationLabel.textColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        businessDurationLabel.textColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)

        standartImageView.image = #imageLiteral(resourceName: "StandartCarRaw")
        premiumImageView.image = #imageLiteral(resourceName: "PremiumCarRaw")
        businessImageView.image = #imageLiteral(resourceName: "BusinessCarRaw")

        standartPriceLabel.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5529411765, alpha: 1)
        premiumPriceLabel.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5529411765, alpha: 1)
        businessPriceLabel.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5529411765, alpha: 1)

        standartOldPriceLabel.isHidden = true
        premiumOldPriceLabel.isHidden = true
        businessOldPriceLabel.isHidden = true

        standartPriceLabel.text = "\(prices[0]) руб"
        premiumPriceLabel.text = "\(prices[1]) руб"
        businessPriceLabel.text = "\(prices[2]) руб"

        recreateViewIfNeeded()
    }
    
    func updateUIWith(scores:Int) {
        scoresEntered = scores
        guard let index = selectedIndex else { return }
        switch index {
            case 0:
                let newPrice = prices[0] - scores
                update(oldLabel: standartOldPriceLabel, label: standartPriceLabel, oldPrice: prices[0], price: newPrice)
            case 1:
                let newPrice = prices[1] - scores
                update(oldLabel: premiumOldPriceLabel, label: premiumPriceLabel, oldPrice: prices[1], price: newPrice)
            case 2:
                let newPrice = prices[2] - scores
                update(oldLabel: businessOldPriceLabel, label: businessPriceLabel, oldPrice: prices[2], price: newPrice)
            default: break
        }
    }
    
    private func update(oldLabel:UILabel,label:UILabel,oldPrice:Int,price:Int) {
        label.text = "\(price) руб"
        
        oldLabel.isHidden = false
        let attrString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(oldPrice) руб")
        attrString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attrString.length))
        oldLabel.attributedText = attrString
    }
    
    
    private func recreateViewIfNeeded() {
        
        guard let index = selectedIndex else { return }
        switch index {
            case 0:
                updateStandartView()
                if scoresEntered != 0 { standartOldPriceLabel.isHidden = false }
            case 1:
                updatePremiumView()
                if scoresEntered != 0 { premiumOldPriceLabel.isHidden = false }
            case 2:
                updateBusinessView()
                if scoresEntered != 0 { businessOldPriceLabel.isHidden = false }
        default:break
        }
    }
    
    
    
}
