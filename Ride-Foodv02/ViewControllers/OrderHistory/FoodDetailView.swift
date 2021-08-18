import UIKit

class FoodDetailView: DetailView {

    //MARK: - Outlets
    
    @IBOutlet weak var shopLabel: UILabel! { didSet {
        shopLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var shopDetailLabel: UILabel!{ didSet {
        shopDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var courierLabel: UILabel!{ didSet {
        courierLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var courierDetailLabel: UILabel!{ didSet {
        courierDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    @IBOutlet weak var orderListLabel: UILabel!{ didSet {
        orderListLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
    }}
    @IBOutlet weak var orderListDetailLabel: UILabel!{ didSet {
        orderListDetailLabel.font = UIFont.SFUIDisplayRegular(size: 12.0)
    }}
    
    //MARK: - UI changes
    
    override func updateUI() {
        super.updateUI()
        
    }

}
