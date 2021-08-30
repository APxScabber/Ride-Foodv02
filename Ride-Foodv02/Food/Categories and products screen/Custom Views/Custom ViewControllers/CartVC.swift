//
//  CartVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.08.2021.
//

import UIKit

class CartVC: UIViewController {


    
    var shopID: Int = 0
    
    var cartTableView = UITableView()
    
    
    let deliveryView  = DeliveryTimeView()
    let promocodeView = PromocodeAndCreditsView(image: UIImage(named: "Promocode")!, title: "Промокод")
    let creditView    = PromocodeAndCreditsView(image: UIImage(named: "scores")!, title: "Баллы")
    
    
    let stackView       = UIStackView()
    let scrollView      = UIScrollView()
    
    let promocodeAndCreditsStackView = UIStackView()
   
    
    let deliveryTimeView = UIView()
    
    var productsInCart: [FoodOrderMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCartProducts()
       
    }
    
    // Business Logic
    
    func retrieveCartProducts(){
        FoodPersistanceManager.shared.fetchAddresses(shopID: shopID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let products):
                self.productsInCart = products
                DispatchQueue.main.async {
                    self.cartTableView.reloadData()
                    self.configureTableViewHeightConstraints()
                    
                }
            }
        }
    }
    
   
    // UI Logic
    
//    override func updateViewConstraints() {
//        cartTableView.heightAnchor.constraint(equalToConstant: cartTableView.contentSize.height).isActive = true
//        super.updateViewConstraints()
//    }
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        
    }
    
    func configureUI(){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        configureScrollView()
        configureStackView()
        configureTableView()
        configureDeliveryTimeView()
        configurePromocodeAndCreditsStackView()
    }
    
    func configureScrollView(){
        scrollView.frame                    = view.bounds
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: stackView.frame.height + 600)
    }
    
    func configureStackView(){
        scrollView.addSubview(stackView)
        stackView.axis                                      = .vertical
        stackView.distribution                              = .fill
        stackView.spacing                                   = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor)
        ])
        
    }
    
    func configureDeliveryTimeView(){
        stackView.addArrangedSubview(deliveryView)
        deliveryView.translatesAutoresizingMaskIntoConstraints = false
        deliveryView.set(with: 45, deliveryPrice: 0)
        
        NSLayoutConstraint.activate([
            deliveryView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            deliveryView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            deliveryView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    
    
    func configureTableView(){
        stackView.addArrangedSubview(cartTableView)
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseID)
        
        cartTableView.invalidateIntrinsicContentSize()
        cartTableView.estimatedRowHeight = 40
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        cartTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.layoutIfNeeded()
        cartTableView.isScrollEnabled = false
        
       
        NSLayoutConstraint.activate([
            cartTableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        configureTableViewHeightConstraints()
      
        
    }
    
    func configureTableViewHeightConstraints(){
        if productsInCart.isEmpty{
            cartTableView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        else {
            print("content size is \(cartTableView.contentSize.height)")
            cartTableView.heightAnchor.constraint(equalToConstant: cartTableView.contentSize.height ).isActive = true
        }
    }
    
    
    func configurePromocodeAndCreditsStackView(){
        stackView.addArrangedSubview(promocodeAndCreditsStackView)
        promocodeAndCreditsStackView.axis                                      = .horizontal
        promocodeAndCreditsStackView.distribution                              = .fillEqually
        promocodeAndCreditsStackView.spacing                                   = 3
        promocodeAndCreditsStackView.translatesAutoresizingMaskIntoConstraints = false
        promocodeAndCreditsStackView.addArrangedSubview(promocodeView)
        promocodeAndCreditsStackView.addArrangedSubview(creditView)
        
        NSLayoutConstraint.activate([
            promocodeAndCreditsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            promocodeAndCreditsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            promocodeAndCreditsStackView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

}

extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseID, for: indexPath) as! CartTableViewCell
        let product = productsInCart[indexPath.row]
        cell.set(with: product)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    
}
