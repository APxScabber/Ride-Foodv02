import UIKit

protocol FoodTaxiViewDelegate: AnyObject {
    func goToFood()
    func goToTaxi()
}

class FoodTaxiView: UIView {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var taxiImageView: UIImageView!
    
    @IBOutlet weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    @IBOutlet weak var placeAnnotationView: UIImageView!
    
    weak var delegate: FoodTaxiViewDelegate?
    
    
    @objc
    private func foodImageViewClicked(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.goToFood()
        }
    }
    
    @objc
    private func taxiImageViewClicked(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            delegate?.goToTaxi()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 15.0
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
}
