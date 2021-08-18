import UIKit

class DetailView: RoundedView {
    
    var order: Order? { didSet { updateUI() }}
    func updateUI() {}
    
    //MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel! { didSet {
        dateLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var orderLabel: UILabel! { didSet {
        orderLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var orderDetailLabel: UILabel! { didSet {
        orderDetailLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var toLabel: UILabel! { didSet {
        toLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var toLocationLabel: UILabel! { didSet {
        toLocationLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
        
    @IBOutlet weak var priceLabel: UILabel! { didSet {
        priceLabel.font = UIFont.SFUIDisplayRegular(size: 17.0)
    }}
    
    @IBOutlet weak var paymentLabel: UILabel! { didSet {
        paymentLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
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
        cornerRadius = 15.0
        colorToFill = .white
    }
}

class TaxiDetailView: DetailView {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var tariffRoundedView: RoundedView! { didSet {
        tariffRoundedView.cornerRadius = 15.0
    }}
    
    @IBOutlet weak var tariffLabel: UILabel! { didSet {
        tariffLabel.font = UIFont.SFUIDisplayRegular(size: 10.0)
    }}
    
    @IBOutlet weak var fromLabel: UILabel! { didSet {
        fromLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
        
    @IBOutlet weak var fromLocationLabel: UILabel! { didSet {
        fromLocationLabel.font = UIFont.SFUIDisplaySemibold(size: 12.0)
    }}
    
    
    @IBOutlet weak var driverLabel: UILabel! { didSet {
        driverLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var driverDetailLabel: UILabel! { didSet {
        driverDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var carLabel: UILabel! { didSet {
        carLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var carDetailLabel: UILabel! { didSet {
        carDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var numberLabel: UILabel! { didSet {
        numberLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var numberDetailLabel: UILabel! { didSet {
        numberDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var regionLabel: UILabel! { didSet {
        regionLabel.font = UIFont.SFUIDisplayRegular(size: 8.0)
    }}
    
    @IBOutlet weak var timeLabel: UILabel! { didSet {
        timeLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    @IBOutlet weak var timeDetailLabel: UILabel! { didSet {
        timeDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
   
    
    
    //MARK: - UI update
    
    override func updateUI() {
        super.updateUI()
        
        tariffLabel.text = order?.tariff
        dateLabel.text = order?.date
        orderDetailLabel.text = order?.typeDetail
        orderLabel.text = order?.type
        fromLocationLabel.text = order?.from
        toLocationLabel.text = order?.to
        
        driverDetailLabel.text = order?.taxi?.driver
        carDetailLabel.text = "\(order!.taxi!.carColor) \(order!.taxi!.car))"
        numberDetailLabel.text = order?.taxi?.number
        regionLabel.text = "\(order!.taxi!.region)"
        timeDetailLabel.text = "15 минут"
        priceLabel.text = "\(order!.price) руб"
        paymentLabel.text = "Платеж №534632463426"
        
        switch order?.tariff {
            case "Standart": tariffRoundedView.colorToFill = #colorLiteral(red: 0.6274509804, green: 1, blue: 0.2980392157, alpha: 1)
            case "Premium": tariffRoundedView.colorToFill = #colorLiteral(red: 0.768627451, green: 0.2588235294, blue: 0.9490196078, alpha: 1)
            case "Business": tariffRoundedView.colorToFill = #colorLiteral(red: 0.831372549, green: 0.7411764706, blue: 0.5019607843, alpha: 1)
            default: break
        }
        
    }
    
   
}
