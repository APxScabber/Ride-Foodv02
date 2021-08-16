//
//  CategoriesAndFoodVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 16.08.2021.
//

import UIKit

class CategoriesAndFoodVC: UIViewController {
    
    var shopName: String = ""
    var mainCategoryName: String = ""
    var shopID: Int = 0
    var CategoryID: Int = 0
    
    var product: ProductData?
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var shopTitleLabel: UILabel! {didSet{
        shopTitleLabel.font = UIFont.SFUIDisplayRegular(size: 15)
    }}
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel! {didSet{
        titleLabel.font = UIFont.SFUIDisplaySemibold(size: 26)
    }}
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tinySeparatorView: UIView!
    
    @IBOutlet weak var draggableRoundView: RoundedView!
    
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
       print(shopID)
        print(CategoryID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        getProducts(shopID: shopID, categoryID: CategoryID, page: 1)
        
    }
   
    func getProducts(shopID: Int, categoryID: Int, page: Int){
        ProductsNetworkManager.shared.getProducts(shopID: shopID, parentCategoryID: categoryID, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.product = data
                print(self.product)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
         if !hasSetPointOrigin {
             hasSetPointOrigin = true
             pointOrigin = self.view.frame.origin
         }
     }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setUpViews(){
//        Set storyboard label values
        titleLabel.text = mainCategoryName
        shopTitleLabel.text = shopName 
        
        
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
                     self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
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
