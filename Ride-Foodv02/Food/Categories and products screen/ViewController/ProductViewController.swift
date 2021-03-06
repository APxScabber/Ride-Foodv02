//
//  ProductViewController.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 23.08.2021.
//

import UIKit

protocol FoodOrderDelegate: AnyObject {
    func productWasAddedToTheCart()
}

class ProductViewController: UIViewController {
    
    var shopID: Int = 0
    
    weak var delegate: FoodOrderDelegate?
    
    var overallSum: Int = 0
    
    let topCellImageView = UIImageView(image: UIImage(named: "topSell"))
    
    var onSaleView = OnSaleView()
    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var ProductImageView: UIImageView!
    
    @IBOutlet weak var ExitButton: UIButton!
    
    @IBOutlet weak var ProductDescriptionStackView: UIStackView!
    
    @IBOutlet weak var ProductNameLabel: UILabel!
    
    @IBOutlet weak var productCompositionLabel: UILabel!
    
    @IBOutlet weak var ProductManufacturerLabel: UILabel!
    
    @IBOutlet weak var productManufacturerCountryLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel! { didSet {
        productPriceLabel.font = UIFont.SFUIDisplaySemibold(size: 17.0)
    }}
    
    @IBOutlet weak var AddToTheCartButton: UIButton! { didSet{
//        AddToTheCartButton.layer.cornerRadius = 15
        AddToTheCartButton.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17.0)
        AddToTheCartButton.titleLabel?.minimumScaleFactor = 0.5
        AddToTheCartButton.setTitle(Localizable.Food.toCart.localized, for: .normal)
    }}
    
    @IBOutlet weak var AddToTheCartRoundedView: RoundedView! { didSet  {
        AddToTheCartRoundedView.cornerRadius = 15.0
        AddToTheCartRoundedView.colorToFill = #colorLiteral(red: 0.2392156863, green: 0.231372549, blue: 1, alpha: 1)
    }}
    
    @IBOutlet weak var QTYPlusButton: UIButton!
    
    @IBOutlet weak var QTYMinusButton: UIButton!
    
    @IBOutlet weak var QTYLbel: UILabel! {didSet{
       
        QTYLbel.text = "\(qty)"
    }}
    
    
    var qty: Int = 1
    
    var product = Product()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainView()
        setViews(with: product)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
         if !hasSetPointOrigin {
             hasSetPointOrigin = true
             pointOrigin = self.view.frame.origin
        
         }
     }
    
    @IBAction func Exit(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func IncreaseQTY(_ sender: Any) {
        qty += 1
        QTYLbel.text = "\(qty)"
        if let price = product.price {
            setPriceLabelData(price: price, qty: qty)
        }
        
    }
    
    @IBAction func DecreaseQTY(_ sender: Any) {
        guard qty > 1 else {
            return
        }
        qty -= 1
        QTYLbel.text = "\(qty)"
        if let price = product.price {
            setPriceLabelData(price: price, qty: qty)
        }
    }
    
    func calculateOverallPrice(price: Int, count: Int) -> Int{
        var sumToPay = Int()
        sumToPay = price * count
        return sumToPay
    }
    
    func setPriceLabelData(price: Int, qty: Int){
        overallSum = calculateOverallPrice(price: price, count: qty)
        productPriceLabel.text = "\(overallSum) \(Localizable.Delivery.deliveryMoney.localized)"
    }
    
    
    
    
    @IBAction func AddToTheCart(_ sender: Any) {
        
        guard qty >= 1 else {
            print("invalid qty of products")
            return
        }
        FoodPersistanceManager.shared.saveCoreDataInstance(product: product, qty: qty, shopID: shopID)
        delegate?.productWasAddedToTheCart()
        dismiss(animated: true, completion: nil)
    }
    
    func createDescriptionStrings(with data: Product){
        
    }
    
    func setViews(with data: Product){
        self.showLoadingView()
        
        if data.hit != 0{
            addTopCellImageView()
        } else {
            topCellImageView.removeFromSuperview()
        }
        
        if let sale = data.sale, sale != 0{
            topCellImageView.removeFromSuperview()
            addSaleView(with: sale)
        } else {
            onSaleView.removeFromSuperview()
        }
        
        ProductNameLabel.text = data.name
        if let price = data.price, qty != 0{
          setPriceLabelData(price: price, qty: qty)
        }
        
        
        productCompositionLabel.attributedText = UIHelper.createTitleAttributedString(titleString: "Состав: ", font: UIFont.SFUIDisplayRegular(size: 17)!, color: UIColor.black, bodyString: data.composition ?? "", bodyColor: UIColor.DarkGrayTextColor)
        ProductManufacturerLabel.attributedText = UIHelper.createTitleAttributedString(titleString: "Производитель: ", font: UIFont.SFUIDisplayRegular(size: 17)!, color: UIColor.black, bodyString: "Неизвестен", bodyColor: UIColor.DarkGrayTextColor)
        productManufacturerCountryLabel.attributedText = UIHelper.createTitleAttributedString(titleString: "Страна: ", font: UIFont.SFUIDisplayRegular(size: 17)!, color: UIColor.black, bodyString: data.producing ?? "Страна неизвестна", bodyColor: UIColor.DarkGrayTextColor)
        
        QTYLbel.backgroundColor = UIColor.SeparatorColor
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let imageData = data.icon{
                let url = URL(string: imageData)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                    self.ProductImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                }
               
            }
        }
        
    }
    
    func addSaleView(with salePercentage: Int){
        onSaleView = OnSaleView(salePercentage: salePercentage)
        ProductDescriptionStackView.addSubview(onSaleView)
        
        NSLayoutConstraint.activate([
            onSaleView.bottomAnchor.constraint(equalTo: ProductDescriptionStackView.topAnchor, constant: -18),
            onSaleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            onSaleView.heightAnchor.constraint(equalToConstant: 23),
            onSaleView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func addTopCellImageView(){
        ProductDescriptionStackView.addSubview(topCellImageView)
        topCellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topCellImageView.bottomAnchor.constraint(equalTo: ProductDescriptionStackView.topAnchor, constant: -18),
            topCellImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            topCellImageView.heightAnchor.constraint(equalToConstant: 23),
            topCellImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
        
    }
    
    
    func setUpMainView(){

        
        containerView.layer.cornerRadius = 15.0
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
       
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
              view.addGestureRecognizer(panGesture)
        
    }
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: view)

         // Not allowing the user to drag the view upward
         guard translation.y >= 0 else { return }

         // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)

         if sender.state == .ended {
             let dragVelocity = sender.velocity(in: view)
             if dragVelocity.y >= 1300 {
                 // Velocity fast enough to dismiss the uiview
                 self.dismiss(animated: true, completion: nil)
             } else {
                 // Set back to original position of the view controller
                 UIView.animate(withDuration: 0.3) {
                     self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 300)
                 }
             }
         }
     }


}
