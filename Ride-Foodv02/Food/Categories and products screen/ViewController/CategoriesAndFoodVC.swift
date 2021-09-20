//
//  CategoriesAndFoodVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 16.08.2021.
//

import UIKit

enum PresentedScreen{
    case subcategories, cart
}

class CategoriesAndFoodVC: BaseViewController {

//MARK: - API
    
    var productsInCartView: FoodOrderBottomView?
    
    let trashBinButton = UIButton()
    
    let emptyCartView = EmptyCartView()
    
    let tableViewCellID = "tableViewCellID"
    
    var showSubcategories: Bool = false
    
    var subcategoriesTableView: UITableView!
    
    var productsCollectionView: UICollectionView!
    
    var subcategoriesCollectionView: UICollectionView!
    
    let scoresView = ScoresView.initFromNib()
    let promocodeToolbar = PromocodeToolbar.initFromNib()
    
    var shopName: String = ""
    var mainCategoryName: String = ""
    var shopID: Int = 0
    var CategoryID: Int = 0
    private var keyboardHeight: CGFloat = 0.0

    var page = 1
    var hasMorePages: Bool = true
    
    var productData: ProductData?
    
    var products: [Product] = []
    var subcategories: [Product] = []
    
    var productsInCart: [FoodOrderMO] = []
    var overallPriceInCart: Int = 0
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var isPaginating: Bool = false
    
    var isChoosingSubSubCategory: Bool = false
    var previousCategoryID: Int = 0
    
    var presentedScreen: PresentedScreen = .subcategories
    
 //MARK: - Outlets
    
    @IBOutlet weak var shopTitleLabel: UILabel! {didSet{
        shopTitleLabel.font = UIFont.SFUIDisplayRegular(size: 15)
    }}
    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var titleLabel: UILabel! {didSet{
        titleLabel.font = UIFont.SFUIDisplaySemibold(size: 26)
    }}
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var draggableRoundView: SwipeDownView!
    @IBOutlet weak var transparentView: TopRoundedView!
    
    //MARK: - UIViews
    
    let contentView = UIView()

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
    
    
//MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews(screenType: .subcategories)
        promocodeToolbar.isHidden = true
        scoresView.isHidden = true
        view.addSubview(promocodeToolbar)
        view.addSubview(scoresView)
        configureContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts(shopID: shopID, categoryID: CategoryID, page: 1)
        fetchCDOrderInformation(with: .subcategories)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         if !hasSetPointOrigin {
             hasSetPointOrigin = true
             pointOrigin = self.view.frame.origin
        
         }
     }
    
    
    func fetchCDOrderInformation(with screenType: PresentedScreen){
        productsInCart.removeAll()
        FoodPersistanceManager.shared.fetchAddresses(shopID: shopID) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                self.productsInCart = data
                self.presentProductsInCartView(screenType: screenType)
            }
        }
    }
    
    func presentProductsInCartView(screenType: PresentedScreen){
        let padding: CGFloat = 25
        
        overallPriceInCart = 0
        
        if let view = productsInCartView{
            view.removeFromSuperview()
        }
        guard !productsInCart.isEmpty else {
            self.productsInCartView?.removeFromSuperview()
            productsInCartView = nil
            return
        }
        
        productsInCart.forEach { product in
            overallPriceInCart += Int((product.price * product.qty))
        }
        switch screenType{
        case .subcategories:
            productsInCartView = FoodOrderBottomView(title: Localizable.Food.placeOrder.localized, price: overallPriceInCart, oldPrice: nil)
        case .cart:
            productsInCartView = FoodOrderBottomView(title: Localizable.Food.goToPayment.localized, price: overallPriceInCart, oldPrice: nil)
        }
        
        if let bottomView = productsInCartView{
            containerView.addSubview(bottomView)
          
            let tap = UITapGestureRecognizer(target: self, action: #selector(bottomViewTapGestureRecognizerAction))
            bottomView.addGestureRecognizer(tap)
            
            NSLayoutConstraint.activate([
                bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
                bottomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
                bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40),
                bottomView.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
      
        
    }
  
   
    func getProducts(shopID: Int, categoryID: Int, page: Int){
        self.showLoadingView()
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
                if page == data.meta?.lastPage || data.meta?.lastPage == 1  { self.hasMorePages = false}
               
                self.showSubcategories = self.products.isEmpty ? true : false
                
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                    self.updateUI(screenType: .subcategories)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func deleteCart(){
        guard productsInCart.count != 0 else { return }
        presentConfirmWindow(title: Localizable.Food.clearBinQuestion.localized, titleColor: .red, confirmTitle: Localizable.Food.clearBin.localized, cancelTitle: Localizable.Food.cancel.localized)
    }
    
    
    // Configure screen UI
    
    func configureContentView(){
        containerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 2),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
    }
    
    func configureEmptyCartView(){
        contentView.addSubview(emptyCartView)
        emptyCartView.button.addTarget(self, action: #selector(getBackToShops), for: .touchUpInside)
        NSLayoutConstraint.activate([
            emptyCartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emptyCartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyCartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyCartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureTrashButton(){
        containerView.addSubview(trashBinButton)
        trashBinButton.addTarget(self, action: #selector(deleteCart), for: .touchUpInside)
        trashBinButton.setImage(UIImage(named: "trashBin"), for: .normal)
        trashBinButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trashBinButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
            trashBinButton.heightAnchor.constraint(equalToConstant: 41),
            trashBinButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -17),
            trashBinButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    //MARK: - deleteProductsAndPresentCart
    
    func deleteProductsAndPresentCart(){
        if presentedScreen == .subcategories {
            self.showLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.removeAllCollectionViews()
                self.setUpViews(screenType: .cart)
                self.configureTrashButton()
                self.fetchCDOrderInformation(with: .cart)
                let cartVC = CartVC()
                cartVC.productsInCart = self.productsInCart
                cartVC.shopID         = self.shopID
                cartVC.delegate       = self
                cartVC.promocodeScoreView.delegate = self
                self.add(childVC: cartVC, to: self.contentView)
                self.dismissLoadingView()
            }
            presentedScreen = .cart
        } else {
            let storyboard = UIStoryboard(name: "Food", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FoodOrderVC") as! FoodOrderVC
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            vc.totalPrice = overallPriceInCart
            present(vc, animated: true)
        }
        
   
    }
    

    
    func updateUI(screenType: PresentedScreen){
        switch screenType {
        case .subcategories:
            DispatchQueue.main.async {
                if self.showSubcategories{
                    self.configureTableView()
                    self.subcategoriesTableView.reloadData()
                } else {
                    if !self.subcategories.isEmpty {
                        self.configureSubcategoriesCollectionViews()
                        self.configureProductsCollectionView()
                        self.reloadProductsCollectionView()
                        self.subcategoriesCollectionView.reloadData()
                    } else {
                        self.configureProductsCollectionView()
                        self.reloadProductsCollectionView()
                    }
                }
            }
        case .cart:
            print("Here we are gonna configure cartscreen")
            
        }
    }
    
    func reloadProductsCollectionView(){
        if isPaginating {
            productsCollectionView.reloadInputViews()
        } else {
            productsCollectionView.reloadData()
           
        }
    }
    
    func removeTableView(){
        subcategoriesTableView.removeFromSuperview()
        subcategories.removeAll()
    }
    
    func removeAllCollectionViews(){
        if let subcategoriesCV = subcategoriesCollectionView{
            subcategoriesCV.removeFromSuperview()
        }
        if let productsCV = productsCollectionView{
            productsCV.removeFromSuperview()
        }
        subcategories.removeAll()
        products.removeAll()
    }
    
    
    func configureTableView(){
        subcategoriesTableView = UITableView(frame: containerView.bounds, style: .plain)
        contentView.addSubview(subcategoriesTableView)
        subcategoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        subcategoriesTableView.delegate = self
        subcategoriesTableView.dataSource = self
        subcategoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellID)
       
        NSLayoutConstraint.activate([
            subcategoriesTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subcategoriesTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subcategoriesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subcategoriesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
    }
    
    func configureSubcategoriesCollectionViews(){
        subcategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createHorizontalCollectionViewFlowLayout(in: containerView))
        contentView.addSubview(subcategoriesCollectionView)
        contentView.addSubview(separatorView)
        subcategoriesCollectionView.backgroundColor = .white
        subcategoriesCollectionView.showsHorizontalScrollIndicator = false
        subcategoriesCollectionView.showsVerticalScrollIndicator = false
        subcategoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        subcategoriesCollectionView.delegate = self
        subcategoriesCollectionView.dataSource = self
        subcategoriesCollectionView.register(SubcategoriesCollectionViewCell.self, forCellWithReuseIdentifier: SubcategoriesCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            subcategoriesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            subcategoriesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subcategoriesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subcategoriesCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            separatorView.topAnchor.constraint(equalTo: subcategoriesCollectionView.bottomAnchor, constant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        
        ])
        
    }
    
    func configureProductsCollectionView(){
        productsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createProductsCollectionViewFlowLayour(in: containerView))
        contentView.addSubview(productsCollectionView)
        productsCollectionView.backgroundColor = .white
        productsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.showsVerticalScrollIndicator = false
        productsCollectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        if !subcategories.isEmpty {
        NSLayoutConstraint.activate([
            productsCollectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            productsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        } else {
            NSLayoutConstraint.activate([
                productsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
                productsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                productsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                productsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
         
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        if isChoosingSubSubCategory{
            if subcategoriesCollectionView != nil, productsCollectionView != nil{
                self.removeAllCollectionViews()
                products.removeAll()
                subcategories.removeAll()
            }
           
            if subcategoriesTableView != nil{
                self.removeTableView()
                subcategories.removeAll()
                products.removeAll()
            }
            self.getProducts(shopID: shopID, categoryID: CategoryID, page: 1)
            isChoosingSubSubCategory = false
        } else {
            dismiss(animated: true)
        }
        
    }
    
    func setUpViews(screenType: PresentedScreen){
        
        switch screenType {
        case .cart:
            titleLabel.text = Localizable.Food.bin.localized
        case .subcategories:
            titleLabel.text = mainCategoryName
       
        }
//        Set storyboard label values
      
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
              containerView.addGestureRecognizer(panGesture)
        
    }
    
    @objc func getBackToShops(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func bottomViewTapGestureRecognizerAction(sender: UITapGestureRecognizer){
        deleteProductsAndPresentCart()
    }

    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
         let translation = sender.translation(in: view)

         guard translation.y >= 0 else { return }
        
         view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)

         if sender.state == .ended {
             let dragVelocity = sender.velocity(in: view)
             if dragVelocity.y >= 1300 {
                 self.dismiss(animated: true, completion: nil)
             } else {
                 UIView.animate(withDuration: 0.3) {
                     self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                 }
             }
         }
     }
 

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.subcategoriesTableView{
            previousCategoryID = CategoryID
            isChoosingSubSubCategory = true
            let subcategory = subcategories[indexPath.row]
            if let id = subcategory.id{
                self.removeTableView()
                self.getProducts(shopID: shopID, categoryID: id, page: 1)
            }
            
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.subcategoriesCollectionView{
           
            isChoosingSubSubCategory = true
            previousCategoryID = CategoryID
            
            let subcategory = subcategories[indexPath.row]
            if let id = subcategory.id{
                self.removeAllCollectionViews()
                self.getProducts(shopID: shopID, categoryID: id, page: 1)
               
            }
        } else {
            let item = products[indexPath.item]
            let storyboard = UIStoryboard(name: "Food", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductVC") as! ProductViewController
            vc.product = item
            vc.delegate = self
            vc.shopID = shopID
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            
            
            self.present(vc, animated: true)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePages else {
                return
            }
            page += 1
            isPaginating = true
            getProducts(shopID: shopID, categoryID: CategoryID, page: page)
            
        }
    }
    
}

extension CategoriesAndFoodVC: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, viewHeightMultiplierPercentage: 0.11)
    }
}

extension CategoriesAndFoodVC: FoodOrderDelegate{
    func productWasAddedToTheCart() {
        self.fetchCDOrderInformation(with: .subcategories)
    }
    
    
}

extension CategoriesAndFoodVC: cartVCDelegate {
    
    func setupKeyboardHeight(_ value: CGFloat) {
        keyboardHeight = value
    }
    
    func updateBottomView() {
        self.fetchCDOrderInformation(with: .cart)
        if productsInCart.isEmpty{
            self.removeChild()
            self.configureEmptyCartView()
        }
    }
}

extension CategoriesAndFoodVC{
    
    func presentConfirmWindow(title: String, titleColor: UIColor, confirmTitle: String, cancelTitle: String){
        let confirmAlert = VBConfirmAlertVC(alertTitle: title, alertColor: titleColor, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
        confirmAlert.foodCartDelegate = self
        if #available(iOS 13.0, *) {
            confirmAlert.modalPresentationStyle = .popover
        } else {
            // Fallback on earlier versions
        }
        confirmAlert.modalTransitionStyle = .coverVertical
        self.present(confirmAlert, animated: true)
    }
}

extension CategoriesAndFoodVC: ClearFoodCartProtocol{
    func clearFoodCart() {
        FoodPersistanceManager.shared.deleteCoreDataInstance(shopID: shopID) { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                print(error?.localizedDescription ?? "Something went wrong")
                return
            }
            self.fetchCDOrderInformation(with: .cart)
            self.removeChild()
            self.configureEmptyCartView()
        }
    }
    
    
}

//MARK: - PromocodeScoresViewDelegate

extension CategoriesAndFoodVC: PromocodeScoresViewDelegate {
    
    func useScores() {
        scoresView.isHidden = false
        transparentView.isHidden = false
        scoresView.delegate = self
//        cartVC.view.isUserInteractionEnabled = false
        containerView.isUserInteractionEnabled = false
        scoresView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 170)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresView.frame.origin.y = self.view.bounds.height - 170 - self.view.safeAreaInsets.bottom - CGFloat(SafeArea.shared.bottom)
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
        transparentView.isHidden = false
        promocodeToolbar.delegate = self
        containerView.isUserInteractionEnabled = false
        promocodeToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: PromocodeConstant.toolbarHeight)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.promocodeToolbar.frame.origin.y = self.view.bounds.height - PromocodeConstant.toolbarHeight - self.keyboardHeight - CGFloat(SafeArea.shared.bottom)
        }

        
    }
    
    
}


extension CategoriesAndFoodVC: ScoresViewDelegate {
    
    func showScoresToolbar() {
//        scoresToolbar.isHidden = false
//        scoresToolbar.scores = scoresView.scores
//        scoresToolbar.textField.becomeFirstResponder()
//        scoresToolbar.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 128)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
         //   self.scoresToolbar.frame.origin.y = self.view.bounds.height - self.keyboardHeight - 128
        }

    }
    
    func closeScoresView() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.scoresView.frame.origin.y = self.view.bounds.height
        }completion: { if $0 == .end {
            self.transparentView.isHidden = true
            self.scoresView.isHidden = true
            self.containerView.isUserInteractionEnabled = true
        }}
    }
    
    func spendAllScores() {
     //   enter(scores: scoresView.scores)
    }
}

//MARK: -  PromocodeToolbarDelegate
extension CategoriesAndFoodVC: PromocodeToolbarDelegate {
    
    func activate(promocode: String) {
        PromocodeActivator.post(code: promocode)
        promocodeToolbar.spinner.startAnimating()
    }
    
    func closePromocodeToolbar() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) {
            self.promocodeToolbar.frame.origin.y = self.view.bounds.height
        } completion: {  if $0 == .end {
            self.promocodeToolbar.isHidden = true
            self.transparentView.isHidden = true
            self.containerView.isUserInteractionEnabled = true
        }
        }
    }
}
