import UIKit

protocol FoodTaxiViewDelegate: AnyObject {
    func goToFood()
    func goToTaxi()
}

class FoodTaxiView: UIView {

    //MARK: - API
    weak var delegate: FoodTaxiViewDelegate?

    //MARK: - Outlets
    
    @IBOutlet weak var foodImageView: UIImageView! { didSet {
        foodImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(foodImageViewClicked(_:))))
        foodImageView.isExclusiveTouch = true
    }}
    
    @IBOutlet weak var taxiImageView: UIImageView! { didSet {
        taxiImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(taxiImageViewClicked(_:))))
        taxiImageView.isExclusiveTouch = true
    }}
    
    @IBOutlet weak var placeLabel: UILabel! { didSet {
        placeLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    @IBOutlet weak var placeAnnotationView: UIImageView!
    
    
    //MARK: - Delegation
    
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
        layer.cornerRadius = 15.0
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
}
