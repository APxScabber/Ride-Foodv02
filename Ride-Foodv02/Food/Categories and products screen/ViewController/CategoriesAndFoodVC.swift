//
//  CategoriesAndFoodVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 16.08.2021.
//

import UIKit

class CategoriesAndFoodVC: UIViewController {
    
    let TestSubcategories = ["Йогурты", "Замороженная продукция", "Полуфабрикаты", "Глазированные сырки", "Квас", "Творог"]
    
    let tableViewCellID = "tableViewCellID"
    
    var showSubcategories: Bool = false { didSet {
        updateUI()
    }}
    
    var subcategoriesTableView: UITableView!
    
    var productsCollectionView: UICollectionView!
    
    var subcategoriesCollectionView: UICollectionView!
    
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
    
    
    @IBOutlet weak var draggableRoundView: RoundedView!
    
    var topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ProfileButtonBorderColor
        return view
    }()
    
     var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ProfileButtonBorderColor
        return view
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUpViews()
    }
    
    func updateUI(){
        DispatchQueue.main.async {
            if self.showSubcategories{
                self.configureTableView()
                self.subcategoriesTableView.reloadData()
            } else {
                self.configureSubcategoriesCollectionViews()
                self.configureProductsCollectionView()
                self.productsCollectionView.reloadData()
                self.subcategoriesCollectionView.reloadData()
            }
        }
      
    }
    
    func configureProductsCollectionView(){
        productsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createProductsCollectionViewFlowLayour(in: containerView))
        containerView.addSubview(productsCollectionView)
        productsCollectionView.backgroundColor = .white
        productsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.showsVerticalScrollIndicator = false
        productsCollectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            productsCollectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            productsCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            productsCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            productsCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
    
    func configureSubcategoriesCollectionViews(){
        subcategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHorizontalCollectionViewFlowLayout(in: containerView))
        containerView.addSubview(subcategoriesCollectionView)
        containerView.addSubview(separatorView)
        subcategoriesCollectionView.backgroundColor = .white
        subcategoriesCollectionView.showsHorizontalScrollIndicator = false
        subcategoriesCollectionView.showsVerticalScrollIndicator = false
        subcategoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        subcategoriesCollectionView.delegate = self
        subcategoriesCollectionView.dataSource = self
        subcategoriesCollectionView.register(SubcategoriesCollectionViewCell.self, forCellWithReuseIdentifier: SubcategoriesCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            subcategoriesCollectionView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 1),
            subcategoriesCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subcategoriesCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            subcategoriesCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            separatorView.topAnchor.constraint(equalTo: subcategoriesCollectionView.bottomAnchor, constant: 1),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        
        ])
        
    }
    
    func configureTableView(){
        subcategoriesTableView = UITableView(frame: containerView.bounds, style: .plain)
        containerView.addSubview(subcategoriesTableView)
        subcategoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        subcategoriesTableView.delegate = self
        subcategoriesTableView.dataSource = self
        subcategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellID)
       
        NSLayoutConstraint.activate([
            subcategoriesTableView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 2),
            subcategoriesTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            subcategoriesTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subcategoriesTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
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
        
        containerView.addSubview(topSeparatorView)
        
        NSLayoutConstraint.activate([
            topSeparatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topSeparatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
      
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
        TestSubcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let subcategory = TestSubcategories[indexPath.row]
        cell.textLabel?.text = subcategory
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    
}

extension CategoriesAndFoodVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.subcategoriesCollectionView{
            return subcategories.count
        } else {
            return products.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.subcategoriesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubcategoriesCollectionViewCell.identifier, for: indexPath) as! SubcategoriesCollectionViewCell
            let subcategory = subcategories[indexPath.row]
            cell.titleLabel.text = subcategory.name
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
            let product = products[indexPath.row]
            cell.setData(product: product)
            return cell
        }
    
    }
    
    
}