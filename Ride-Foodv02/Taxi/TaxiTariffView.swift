import UIKit

protocol TaxiTariffViewDelegate: AnyObject {
    func useScores()
    func userPromocode()
}

class TaxiTariffView: UIView {

    weak var delegate: TaxiTariffViewDelegate?
    
    var usedScores = false
    var usedPromocode = false
    
    @IBOutlet weak var scoresLabel: UILabel! { didSet {
        scoresLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        scoresLabel.text = Localizable.Promocode.scores.localized
    }}
    @IBOutlet weak var scoresImageView: UIImageView!
    
    @IBOutlet weak var promocodeLabel: UILabel! { didSet {
        promocodeLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        promocodeLabel.text = Localizable.Promocode.promocode.localized
    }}
    @IBOutlet weak var promocodeImageView: UIImageView!
    @IBOutlet weak var scoresEnterValueLabel: UILabel! { didSet {
        scoresEnterValueLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
    }}
    
    @IBOutlet weak var scoresEnteredLabel: UILabel! { didSet {
        scoresEnteredLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
        scoresEnteredLabel.text = Localizable.Scores.scoresAvailable.localized
    }}
    
    @IBOutlet weak var scoresRoundedView: RoundedView! { didSet {
        setup(scoresRoundedView)
    }}
    
    @IBOutlet weak var promocodeRoundedView: RoundedView! { didSet {
        setup(promocodeRoundedView)
    }}
    
    
    @IBOutlet weak var standartRoundedView: RoundedView! { didSet {
        setup(standartRoundedView)
    }}
    @IBOutlet weak var standartLabel: UILabel! { didSet {
        standartLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var standartPriceLabel: UILabel! { didSet {
        standartPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    @IBOutlet weak var standartDurationLabel: UILabel! { didSet {
        standartDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    
    
    @IBOutlet weak var premiumRoundedView: RoundedView! { didSet {
        setup(premiumRoundedView)
    }}
    @IBOutlet weak var premiumLabel: UILabel! { didSet {
        premiumLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var premiumPriceLabel: UILabel! { didSet {
        premiumPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    @IBOutlet weak var premiumDurationLabel: UILabel! { didSet {
        premiumDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    
    @IBOutlet weak var businessRoundedView: RoundedView! { didSet {
        setup(businessRoundedView)
    }}
    @IBOutlet weak var businessLabel: UILabel! { didSet {
        businessLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var businessPriceLabel: UILabel! { didSet {
        businessPriceLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    @IBOutlet weak var businessDurationLabel: UILabel! { didSet {
        businessDurationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    //MARK: - Actions
    
    @IBAction func useScores(_ sender: UIButton) {
        delegate?.useScores()
    }
    
    @IBAction func usePromocode(_ sender: UIButton) {
        delegate?.userPromocode()
    }
    
    private func setup(_ roundedView: RoundedView) {
        roundedView.colorToFill = .white
        roundedView.cornerRadius = 15.0
    }

    

    
    
}
