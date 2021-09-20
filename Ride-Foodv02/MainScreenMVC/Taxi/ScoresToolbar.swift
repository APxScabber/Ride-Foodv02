import UIKit

protocol ScoresToolbarDelegate: AnyObject {
    func closeScoresToolbar()
    func enter(scores:Int)
}

class ScoresToolbar: UIView {

    //MARK: - API
    weak var delegate: ScoresToolbarDelegate?
    var scores = 0
    
    //MARK: - Outlets
    
    @IBOutlet weak var textField: UITextField! { didSet {
        textField.font  = UIFont.SFUIDisplayLight(size: 17.0)
        textField.placeholder = Localizable.Scores.scoresEnter.localized
        textField.addTarget(self, action: #selector(updateUI), for: .editingChanged)
    }}
    
    @IBOutlet weak var underBarLine: UIView!
    @IBOutlet weak var errorLabel: UILabel! { didSet {
        errorLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
        errorLabel.text = Localizable.Scores.scoresError.localized
    }}
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.cornerRadius = 15.0
        roundedView.colorToFill = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
    }}
    
    @IBOutlet weak var confirmButton: UIButton! { didSet {
        confirmButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        confirmButton.setTitle(Localizable.Food.confirm.localized, for: .normal)
    }}
    
    //MARK: - Action
    
    @IBAction func enter(_ sender:UIButton) {
        if let scores = Int(textField.text ?? ""),
           scores <= self.scores {
            delegate?.enter(scores: scores)
        }
    }
    
    @objc
    private func updateUI() {
        errorLabel.isHidden = true
        underBarLine.backgroundColor = (textField.text ?? "").isEmpty ?  #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) :  #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        roundedView.colorToFill = (textField.text ?? "").isEmpty ?  #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1) :  #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        confirmButton.isUserInteractionEnabled = !(textField.text ?? "").isEmpty
        
        if let currentScores = Int(textField.text ?? ""),
           currentScores > scores {
            errorLabel.isHidden = false
            underBarLine.backgroundColor = .red
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
    
    @objc
    private func close(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.closeScoresToolbar()
        }
    }
    
}
