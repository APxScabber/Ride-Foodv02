import UIKit

protocol ToAddressDetailViewDelegate: AnyObject {
    func toAddressDetailConfirm()
}
class ToAddressDetailView: UIView {

    weak var delegate: ToAddressDetailViewDelegate?
    var isTextEmpty = true
    
    //MARK: - Outlets
    
    @IBOutlet weak var infoLabel: UILabel! { didSet {
        infoLabel.font = UIFont.SFUIDisplayLight(size: 12.0)
        infoLabel.textColor = TaxiSpecifyFromToColor.white.value
        infoLabel.text = Localizable.Taxi.infoToLabel.localized
    }}
    @IBOutlet weak var blurEffectView: UIVisualEffectView! { didSet {
        blurEffectView.alpha = UserDefaultsManager.shared.isFirstEnterTaxi ? 0.75 : 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToBlur))
        blurEffectView.addGestureRecognizer(tap)
    }}
    
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var topCorneredView: TopRoundedView!
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }}
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    
    @IBOutlet weak var textField: UITextField! { didSet {
        textField.font = UIFont.SFUIDisplayLight(size: 17.0)
        textField.placeholder = Localizable.Taxi.toAddressDetail.localized
        textField.addTarget(self, action: #selector(updateUI), for: .editingChanged)
    }}
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        let title = isTextEmpty ? Localizable.Taxi.skip.localized : Localizable.Taxi.confirm.localized
        confirmButton.setTitle(title, for: .normal)
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    //MARK: - Action
    
    @IBAction func confirm(_ sender: UIButton) {
        delegate?.toAddressDetailConfirm()
    }
    
    @objc func tapToBlur() {
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.alpha = 0
        }
        UserDefaultsManager.shared.isFirstEnterTaxi = false
    }

    
    //MARK: - Text field
    @objc
    func updateUI() {
        isTextEmpty = textField.text == "" ? true : false
        let title = isTextEmpty ? Localizable.Taxi.skip.localized : Localizable.Taxi.confirm.localized
        confirmButton.setTitle(title, for: .normal)
        lineView.backgroundColor = (textField.text ?? "").isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        roundedView.colorToFill = (textField.text ?? "").isEmpty ? #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) : #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        confirmButton.isUserInteractionEnabled = !((textField.text ?? "").isEmpty)
    }
}
