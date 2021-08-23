//
//  ProductViewController.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 23.08.2021.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var ProductImageView: UIImageView!
    
    @IBOutlet weak var ExitButton: UIButton!
    
    @IBOutlet weak var ProductDescriptionStackView: UIStackView!
    
    @IBOutlet weak var ProductNameLabel: UILabel!
    
    @IBOutlet weak var productCompositionLabel: UILabel!
    
    @IBOutlet weak var ProductManufacturerLabel: UILabel!
    
    @IBOutlet weak var productManufacturerCountryLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var AddToTheCartButton: UIButton! { didSet{
        AddToTheCartButton.layer.cornerRadius = 15
    }}
    
    @IBOutlet weak var QTYPlusButton: UIButton!
    
    @IBOutlet weak var QTYMinusButton: UIButton!
    
    @IBOutlet weak var QTYLbel: UILabel! {didSet{
       
        QTYLbel.text = "\(qty)"
    }}
    
    
    var qty: Int = 0
    
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
    }
    
    @IBAction func DecreaseQTY(_ sender: Any) {
        guard qty > 0 else {
            return
        }
        qty -= 1
        QTYLbel.text = "\(qty)"
    }
    
    
    
    
    @IBAction func AddToTheCart(_ sender: Any) {
    }
    
    func createDescriptionStrings(with data: Product){
        
    }
    
    func setViews(with data: Product){
        self.showLoadingView()
        ProductNameLabel.text = data.name
        productPriceLabel.text = "\(data.price ?? 0) руб"
        productCompositionLabel.attributedText = UIHelper.createTitleAttributedString(titleString: "Состав: ", font: UIFont.SFUIDisplayRegular(size: 17)!, color: UIColor.black, bodyString: data.composition ?? "")
        ProductManufacturerLabel.attributedText = UIHelper.createTitleAttributedString(titleString: "Производитель: ", font: UIFont.SFUIDisplayRegular(size: 17)!, color: UIColor.black, bodyString: "Неизвестен")
        productManufacturerCountryLabel.attributedText = UIHelper.createTitleAttributedString(titleString: "Страна: ", font: UIFont.SFUIDisplayRegular(size: 17)!, color: UIColor.black, bodyString: data.producing ?? "Страна неизвестна")
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
