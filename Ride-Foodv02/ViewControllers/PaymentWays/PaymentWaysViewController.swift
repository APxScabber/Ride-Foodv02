//
//  PaymentWaysViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import UIKit

class PaymentWaysViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var linkCardButtonOutlet: UIButton!
    
    // MARK: - Properties
    
    var navigationTitle = PaymentMainViewText.topTitle.text()
    
    let cellHeight: CGFloat = 44
    var selectedCell: IndexPath?
    
    var textPaymentOptions = [[String]]()
    var paymentOptions = [PaymentWaysModel]()
    
    let paymentWaysInteractor = PaymentWaysInteractor()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserID()
        navigationItem.title = navigationTitle

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        bgImageView.image = #imageLiteral(resourceName: "paymentWaysBG")
        
        linkCardButtonOutlet.alpha = 0
        isFirstEnter()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPaymentData()
    }
    
    // MARK: - Methods
    
    //Настройка кнопки Привязать карту
    private func setupLinkCardButton() {

        if textPaymentOptions[1].count == 1 {
            linkCardButtonOutlet.style()
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.blueColor.value
            linkCardButtonOutlet.setTitle(PaymentMainViewText.addButtonText.text(), for: .normal)
            linkCardButtonOutlet.alpha = 1
        } else {
            linkCardButtonOutlet.alpha = 0
        }
    }
    
    // Получаем данные о картах с сервера и в соответствии c этим заполняем Table View
    private func getPaymentData() {
        
        guard let userID = userID else { return }
        tableView.isUserInteractionEnabled = false
        textPaymentOptions = [[PaymentMainViewText.cashTV.text(), "Apple Pay"], [PaymentMainViewText.scoresTV.text()]]
        
        paymentWaysInteractor.loadPaymentData(userID: userID) { modelsArray in
            
            DispatchQueue.main.async {
                self.paymentOptions = []
                self.paymentOptions = modelsArray
                self.createPaymentOptions()
                self.setupLinkCardButton()
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = true
            }
        }
    }
    
    // Определяем есть ли у пользователя уже привязанные к аккаунту карты или нет
    // Формируем массив данных для Table View
    private func createPaymentOptions() {
        
        if paymentOptions.isEmpty {
            let bankCard = PaymentMainViewText.bankCardTV.text()
            textPaymentOptions[0].insert(bankCard, at: 1)
        } else {
            for i in 0 ... paymentOptions.count - 1 {
                let index = i + 1
                textPaymentOptions[0].insert(paymentOptions[i].number, at: index)
            }
            let addCard = PaymentMainViewText.addCardTV.text()
            textPaymentOptions[1].insert(addCard, at: 0)
        }
    }
    
    
    // Устанавливаем в Table View Cell картинку слева
    func setLefImage(for cell: PaymentWaysTableViewCell, section: Int, row: Int) {
        if section == 0 {
            switch row {
            case 0:
                cell.leftImageView.image = #imageLiteral(resourceName: "cash")
                
            case textPaymentOptions[0].count - 1 :
                cell.leftImageView.image = #imageLiteral(resourceName: "applePay")
                
            default:
                if paymentOptions.isEmpty {
                    cell.leftImageView.image = #imageLiteral(resourceName: "one")
                } else {
                    cell.leftImageView.image = #imageLiteral(resourceName: "visa")
                }
            }
        } else {
            if textPaymentOptions[1].count == 1 {
                cell.leftImageView.image = UIImage(named: "scores")
            } else {
                switch row {
                case 1:
                    cell.leftImageView.image = UIImage(named: "scores")
                default:
                    cell.leftImageView.image = nil
                }
            }
        }
    }
    
    // Устанавливаем в Table View Cell картинку справа
    func setRightImage(for cell: PaymentWaysTableViewCell, section: Int, row: Int) {
        if section == 0 {
            if paymentOptions.isEmpty {
                switch row {
                case 1:
                    cell.rightImageView.image = #imageLiteral(resourceName: "rightArrow")
                default :
                    cell.rightImageView.image = row == selectedCell?.row ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
                }
            } else {
//                cell.rightImageView.image = row == selectedCell?.row ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
                cell.rightImageView.image = row == CurrentPayment.shared.id ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
            }
        } else {
            cell.rightImageView.image = #imageLiteral(resourceName: "rightArrow")
        }
    }
    
    //Проверяем первый ли это вход, если да, то показываем общее количество бонусных баллов
    private func isFirstEnter() {
        
        let isFirst = UserDefaultsManager.shared.isFirstEnterPaymentWays
        
        if isFirst {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CongratulationsScores") as! CongratulationsScoresViewController
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true, completion: nil)
            
            UserDefaultsManager.shared.isFirstEnterPaymentWays = false
        }
    }
    
    // MARK: - Actions
    
    //Действие по нажатию на кнопку Привязать карту
    @IBAction func linkCardButtonAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Действие по нажатию на кнопку Назад
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
