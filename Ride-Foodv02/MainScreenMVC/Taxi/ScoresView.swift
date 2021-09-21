import UIKit

protocol ScoresViewDelegate: AnyObject {
    func closeScoresView()
    func spendAllScores()
    func showScoresToolbar()
}

class ScoresView: UIView {

    //MARK: - API
    
    var scores = 0 { didSet {
        scoresLabel.text = "\(scores) \(Localizable.Scores.scoresAvailable.localized)"
    }}
    weak var delegate: ScoresViewDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var meLabel: UILabel! { didSet {
        meLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
        meLabel.text = Localizable.Scores.me.localized
    }}
    
    @IBOutlet weak var scoresLabel: UILabel! { didSet {
        scoresLabel.font = UIFont.SFUIDisplayRegular(size: 17.0 )
    }}
    
    @IBOutlet weak var roundedView: RoundedView! { didSet {
        roundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
        roundedView.cornerRadius = 15.0
    }}
    
    @IBOutlet weak var allInButton: UIButton! { didSet {
        allInButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        allInButton.setTitle(Localizable.Scores.allIn.localized, for: .normal)
    }}
    
    @IBOutlet weak var differenceButton: UIButton! { didSet {
        differenceButton.titleLabel?.font = UIFont.SFUIDisplayLight(size: 17.0)
        differenceButton.setTitle(Localizable.Scores.misc.localized, for: .normal)
    }}
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint! { didSet {
        heightConstraint.constant = CGFloat(170.0 + SafeArea.shared.bottom)
    }}
    //MARK: - Actions
    
    
    @IBAction func allIn(_ sender: UIButton) {
        delegate?.spendAllScores()
    }
    
    @IBAction func misc(_ sender: UIButton) {
        delegate?.showScoresToolbar()
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
    private func close(_ reconizer: UISwipeGestureRecognizer) {
        if reconizer.state == .ended {
            delegate?.closeScoresView()
        }
    }
    

}
