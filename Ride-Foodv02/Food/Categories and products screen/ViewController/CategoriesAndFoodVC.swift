//
//  CategoriesAndFoodVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 16.08.2021.
//

import UIKit

class CategoriesAndFoodVC: UIViewController {
    
    let tableViewCellID = "tableViewCellID"
    
    var showSubcategories: Bool = false { didSet {
        updateUI()
    }}
    
    var subcategoriesTableView: UITableView!
    
    var shopName: String = ""
    var mainCategoryName: String = ""
    var shopID: Int = 0
    var CategoryID: Int = 0
    
    var page = 1
    var hasNoMorePages: Bool = true
    
    var productData: ProductData?
    
    var products: [Product] = []
    var subcategories: [Product] = []
    
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
    
    func updateUI(){
        DispatchQueue.main.async {
            if self.showSubcategories{
                self.configureTableView()
                self.subcategoriesTableView.reloadData()
            } else {
                return
            }
        }
      
    }
    
    func configureTableView(){
        subcategoriesTableView = UITableView(frame: containerView.bounds, style: .plain)
        containerView.addSubview(subcategoriesTableView)
        subcategoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        subcategoriesTableView.delegate = self
        subcategoriesTableView.dataSource = self
        subcategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellID)
       
        NSLayoutConstraint.activate([
            subcategoriesTableView.topAnchor.constraint(equalTo: tinySeparatorView.bottomAnchor, constant: 5),
            subcategoriesTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            subcategoriesTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subcategoriesTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
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
                self.productData = data
                self.productData?.data?.forEach({ element in
                    if element.isCategory!{
                        self.subcategories.append(element)
                    } else {
                        self.products.append(element)
                    }
                })
                print(self.products)
                print(self.subcategories)
                if self.products.isEmpty{
                    self.showSubcategories = true
                  
                }
                DispatchQueue.main.async {
                    self.updateUI()
                }
               
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

extension CategoriesAndFoodVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let subcategory = subcategories[indexPath.row]
        cell.textLabel?.text = subcategory.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    
}
