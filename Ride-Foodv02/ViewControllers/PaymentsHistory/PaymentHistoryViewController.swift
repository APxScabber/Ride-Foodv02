//
//  PaymentHistoryViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import UIKit

class PaymentHistoryViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var mainInfoView: UIView!
    @IBOutlet weak var dateBigViewLabel: UILabel!
    @IBOutlet weak var serviceBigViewLabel: UILabel!
    @IBOutlet weak var cardBigViewImage: UIImageView!
    @IBOutlet weak var cardNumberBigViewLabel: UILabel!
    @IBOutlet weak var paymentNumberBigViewLabel: UILabel!
    @IBOutlet weak var infoBigViewLabel: UILabel!
    @IBOutlet weak var priceBigViewLabel: UILabel!
    
    @IBOutlet weak var mainButtonOutlet: UIButton!
    @IBOutlet weak var topButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewInfoBG: UIImageView!
    
    @IBOutlet weak var tintLayer: UIView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var emptyItemsLabel: UILabel!
    
    // MARK: - Properties
    
    var selectedCell: PaymentHistoryTableViewCell?
    var mainInfoViewWidth: CGFloat?
    var mainInfoViewHeight: CGFloat?
    var mainInfoViewPosY: CGFloat?
    
    var tapGesture: UITapGestureRecognizer? = nil
    let paymentHistoryInteractor = PaymentHistoryInteractor()
    
    var paymentHistoryArray = [PaymentHistoryModel]()
    
    let navigationTitle = PaymentHistoryText.navigationTitle.text()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserID()

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
       
        tableView.delegate = self
        tableView.dataSource = self
    
        tintLayer.isHidden = true

        navigationItem.title = navigationTitle
        emptyItemsLabel.text = PaymentHistoryText.emptyList.text()
        
        getPaymentHistoryData()
        checkHistoryEmpty()
    }
    
    // MARK: - Methods
    
    private func getPaymentHistoryData() {
        
        guard let userID = userID else { return }
        
        paymentHistoryInteractor.loadPaymentHistoryData(userID: userID) { data in
            
            self.paymentHistoryArray = data
            DispatchQueue.main.async {
                self.checkHistoryEmpty()
                self.tableView.reloadData()
            }
        }
    }

    func startUISetupMainInfoView(posY: CGFloat, width: CGFloat, height: CGFloat) {
        
        mainInfoView.frame = CGRect(x: 20, y: posY, width: width, height: height)
        
        infoBigViewLabel.alpha = 0
        infoBigViewLabel.frame.size.width = mainInfoView.frame.width - 40
        infoBigViewLabel.frame.size.height = 0
        infoBigViewLabel.translatesAutoresizingMaskIntoConstraints = true
        
        mainButtonOutlet.style()
        mainButtonOutlet.backgroundColor = PaymentHistoryColors.blueColor.value
        mainButtonOutlet.alpha = 0
        topButtonConstraint.constant = 0
        mainViewInfoBG.alpha = 0
        
        tintLayer.isHidden = false
        tintLayer.alpha = 0

        view.addSubview(mainInfoView)
    }
    
    func mainInfoViewAnimationIn(cell: PaymentHistoryTableViewCell) {
        
        topButtonConstraint.constant = 50

        UIView.animate(withDuration: 1) {
            self.mainInfoView.frame.size.height = 399
            //self.mainInfoView.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1) {

            self.mainInfoView.frame.origin.y = self.view.frame.height / 3
        } completion: { _ in

            if let tapGesture = self.tapGesture {
                self.view.addGestureRecognizer(tapGesture)
            }
        }
        
        UIView.animate(withDuration: 1) {
            self.infoBigViewLabel.frame.size.height = 150
            self.infoBigViewLabel.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1) {
            self.infoBigViewLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 1) {
            self.mainButtonOutlet.alpha = 1
        }
        
        UIView.animate(withDuration: 1) {
           // self.topButtonConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.1) {
            self.mainViewInfoBG.alpha = 1
        }
        
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.tintLayer.alpha = 0.4
        }
    }
    
    func mainInfoViewAnimationOut(cell: PaymentHistoryTableViewCell, posY: CGFloat, height: CGFloat) {
        
        topButtonConstraint.constant = 0
        
        UIView.animate(withDuration: 1) {
            self.mainInfoView.frame.size.height = height
        }
        
        UIView.animate(withDuration: 1) {
            
            self.mainInfoView.frame.origin.y = posY
        } completion: { _ in
            
            if let tapGesture = self.tapGesture {
                self.view.removeGestureRecognizer(tapGesture)
                self.mainInfoView.removeFromSuperview()
                self.tintLayer.isHidden = true
            }
        }
        
        UIView.animate(withDuration: 1) {
            self.infoBigViewLabel.frame.size.height = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.infoBigViewLabel.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.mainButtonOutlet.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.9) {
            cell.alpha = 1
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.9) {
            self.mainViewInfoBG.alpha = 0
        }
        
        UIView.animate(withDuration: 1) {
            self.tintLayer.alpha = 0
        }
    }
    
    private func checkHistoryEmpty() {

        if paymentHistoryArray.isEmpty {

            tableView.alpha = 0
            searchBar.alpha = 0
            bgImage.alpha = 1
            emptyItemsLabel.alpha = 1
            
        } else {

            tableView.alpha = 1
            searchBar.alpha = 1
            bgImage.alpha = 0
            emptyItemsLabel.alpha = 0
        }
    }

    func setBigViewData(for cell: PaymentHistoryTableViewCell) {
        
        serviceBigViewLabel.textColor = PaymentHistoryColors.grayColor.value
        priceBigViewLabel.textColor = PaymentHistoryColors.grayColor.value
        infoBigViewLabel.textColor = PaymentHistoryColors.grayColor.value
        
        dateBigViewLabel.text = cell.dateLabel.text
        serviceBigViewLabel.text = cell.serviceLabel.text
        paymentNumberBigViewLabel.text = cell.paymentNumberLabel.text
        priceBigViewLabel.text = cell.priceLabel.text
        cardBigViewImage.image = cell.cardImage.image
        cardNumberBigViewLabel.text = cell.cardNumberLabel.text
        mainButtonOutlet.setTitle(PaymentHistoryText.button.text(), for: .normal)
    }
    
    // MARK: - @objc Methods
    
    @objc func tapOnView() {
        
        guard let selectedCell = selectedCell else { return }
        guard let mainInfoViewPosY = mainInfoViewPosY else { return }
        guard let mainInfoViewHeight = mainInfoViewHeight else { return }
        
        mainInfoViewAnimationOut(cell: selectedCell,
                                 posY: mainInfoViewPosY,
                                 height: mainInfoViewHeight)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}




