//
//  CartVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.08.2021.
//

import UIKit

class CartVC: UIViewController {

    init(products: [FoodOrderMO]) {
        super.init(nibName: nil, bundle: nil)
        self.productsInCart = products
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cartTableView = UITableView()
    let deliveryView  = DeliveryView()
    let promocodeView = PromocodeCreditView()
    let creditView    = PromocodeCreditView()
    
    
    let stackView       = UIStackView()
    let scrollView      = UIScrollView()
    
    var productsInCart: [FoodOrderMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiaryLabel
        configureUI()
        
        
        // Do any additional setup after loading the view.
    }
    
    // Business Logic
    
  
    
   
    // UI Logic
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureScrollView()
    }
    
    func configureUI(){
        configureStackView()
        configureTableView()
    }
    
    func configureScrollView(){
        scrollView.frame                    = view.bounds
        scrollView.backgroundColor          = .systemTeal
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height + 600)
    }
    
    func configureStackView(){
        scrollView.addSubview(stackView)
        stackView.axis                                      = .vertical
        stackView.distribution                              = .fillEqually
        stackView.spacing                                   = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor)
        ])
        
    }
    
    func configureTableView(){
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.identifier)
        cartTableView.delegate = self
        cartTableView.dataSource = self
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

extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier, for: indexPath) as! CartTableViewCell
        
        return cell
    }
    
    
}
