//
//  CartVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.08.2021.
//

import UIKit

protocol cartVCDelegate: AnyObject {
    func updateBottomView()
}

class CartVC: BaseViewController {

    //MARK: - API
    
    var shopID: Int = 0
    
    var cartTableView = UITableView()
    
    
    let deliveryView  = DeliveryTimeView()
    
    let stackView       = UIStackView()
    let scrollView      = UIScrollView()
       
    let promocodeScoreView = PromocodeScoresView.initFromNib()
    let scoresView = ScoresView.initFromNib()
    let promocodeToolbar = PromocodeToolbar.initFromNib()

    let deliveryTimeView = UIView()
    
    var productsInCart: [FoodOrderMO] = []
    
    var delegate: cartVCDelegate?

    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promocodeScoreView.delegate = self
        scrollView.addSubview(promocodeScoreView)
        promocodeToolbar.isHidden = true
        scoresView.isHidden = true
        view.addSubview(promocodeToolbar)
        view.addSubview(scoresView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCartProducts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
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
                }
            }
        }
    }
    
   
    // UI Logic
    

    func configureUI(){
       
        view.backgroundColor = .white
        configureScrollView()
        configureStackView()
        configureTableView()
        configureDeliveryTimeView()
        configurePromocodeScoresView()
    }
    
    func configureScrollView(){

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: scrollView.contentSize.height)
    }
    
    func configureStackView(){
        scrollView.addSubview(stackView)
        stackView.axis                                      = .vertical
        stackView.distribution                              = .fill
        stackView.alignment                                 = .fill
        stackView.spacing                                   = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -120),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
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
        cartTableView.estimatedRowHeight        = 40
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        cartTableView.frame                     = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        cartTableView.delegate                  = self
        cartTableView.dataSource                = self
        cartTableView.layoutIfNeeded()
        cartTableView.isScrollEnabled           = false
        
       
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
            cartTableView.heightAnchor.constraint(equalToConstant: cartTableView.contentSize.height ).isActive = true
        }
    }
    
    func configurePromocodeScoresView() {
        promocodeScoreView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            promocodeScoreView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            promocodeScoreView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            promocodeScoreView.heightAnchor.constraint(equalToConstant: 50),
            promocodeScoreView.topAnchor.constraint(equalTo: deliveryView.bottomAnchor, constant: 10)
        ])
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource

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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: Localizable.Food.remove.localized) { [weak self] (action, view, completionHandler) -> Void in
            guard let self = self else { return }
            let product = self.productsInCart[indexPath.row]
            
            let context = FoodPersistanceManager.shared.context
            context.delete(product)
           
            FoodPersistanceManager.shared.saveContext()
            self.retrieveCartProducts()
            self.delegate?.updateBottomView()
        }
        return UISwipeActionsConfiguration(actions: [action])
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

//MARK: - PromocodeScoresViewDelegate

extension CartVC: PromocodeScoresViewDelegate {
    
    func useScores() {
        scoresView.isHidden = false
        scoresView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 170)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresView.frame.origin.y = self.view.bounds.height - 170
        }
        
        guard let userID = userID else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let totalScoresInteractor = TotalScoresInteractor()
            totalScoresInteractor.loadScores(userID: userID) { data in
                DispatchQueue.main.async {
                    self.scoresView.scores = data.credit
                }
            }
        }

    }
    
    func usePromocode() {
        promocodeToolbar.isHidden = false
        promocodeToolbar.textField.becomeFirstResponder()
        promocodeToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: PromocodeConstant.toolbarHeight)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.promocodeToolbar.frame.origin.y = self.view.bounds.height - PromocodeConstant.toolbarHeight
        }

        
    }
    
    
}
