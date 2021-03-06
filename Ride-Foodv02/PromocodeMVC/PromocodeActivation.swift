import UIKit

protocol PromocodeActivationDelegate: AnyObject {
    func closePromocodeActivationView()
}

class PromocodeActivation: UIView {

    //MARK: - API
    
    weak var delegate: PromocodeActivationDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel! { didSet {
        titleLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
    }}
    
    @IBOutlet weak var bodyLabel: UILabel! { didSet {
        bodyLabel.font = UIFont.SFUIDisplayLight(size: 17.0)
    }}

    @IBOutlet weak var twoRoundedView: TopRoundedView!
    @IBOutlet weak var topRoundedView: RoundedView! { didSet {
        topRoundedView.cornerRadius = 10.0
        topRoundedView.colorToFill = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.49701049)
    }}
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
    
    //MARK: - Dismiss
    @objc
    private func close(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.closePromocodeActivationView()
        }
    }
}
