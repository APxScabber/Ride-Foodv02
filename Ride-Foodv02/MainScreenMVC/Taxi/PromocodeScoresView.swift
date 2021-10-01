import UIKit

protocol PromocodeScoresViewDelegate: AnyObject {
    func useScores()
    func usePromocode()
}

class PromocodeScoresView: UIView {

    //MARK: - API
    private(set) var usedScores = false

    var usedPromocode = false { didSet { updatePromocodeView() }}
    var scores = 0 { didSet { updateScoresView() }}

    weak var delegate: PromocodeScoresViewDelegate?

    //MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!

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
    @IBOutlet weak var promocodeDiscountLabel: UILabel! { didSet {
        promocodeDiscountLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
        promocodeDiscountLabel.isHidden = true
    }}
    @IBOutlet weak var scoresEnterValueLabel: UILabel! { didSet {
        scoresEnterValueLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
    }}

    @IBOutlet weak var scoresEnteredLabel: UILabel! { didSet {
        scoresEnteredLabel.font = UIFont.SFUIDisplayBold(size: 15.0)
        scoresEnteredLabel.text = Localizable.Scores.scoresAvailable.localized
    }}

    @IBOutlet weak var scoresRoundedView: ShadowRoundedView!

    @IBOutlet weak var promocodeRoundedView: ShadowRoundedView!

    @IBAction private func usePromocode(_ sender: UIButton) {
        if !usedPromocode {
            delegate?.usePromocode()
        }
    }

    @IBAction private func useScores(_ sender: UIButton) {
        if !usedScores {
            delegate?.useScores()
        }
    }

    func reset() {
        usedScores = false
        usedPromocode = false
        scores = 0
    }

    private func updatePromocodeView() {
        promocodeRoundedView.colorToFill = usedPromocode ? #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) : .white
        promocodeImageView.isHidden = usedPromocode
        promocodeDiscountLabel.isHidden = !usedPromocode
        promocodeDiscountLabel.text = "-15%"
        promocodeLabel.font = usedPromocode ? UIFont.SFUIDisplayBold(size: 15.0) : UIFont.SFUIDisplayRegular(size: 15.0)


    }

    private func updateScoresView() {
        usedScores = true
        scoresImageView.isHidden = usedScores
        scoresEnteredLabel.isHidden = !usedScores
        scoresRoundedView.colorToFill = usedScores ? #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) : .white
        scoresEnterValueLabel.isHidden = !usedScores
        scoresLabel.isHidden = usedScores
        let minimumScores = min(CurrentPrice.shared.updatedPrice,CurrentPrice.shared.totalDiscount)
        scoresEnterValueLabel.text = "- \(minimumScores)"

    }
}
