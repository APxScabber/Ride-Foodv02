//
//  PaymentWaysViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import UIKit

class PaymentWaysViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var linkCardButtonOutlet: UIButton!
    
    
    var navigationTitle = "Способы оплаты"
    
    //var userID: String?
    
    let cellHeight: CGFloat = 44
    var selectedCell: Int = 0
    
    //var textPaymentOptions = [String]()
    var textPaymentOptions = [[String]]()
    var paymentOptions = [PaymentWaysModel]()
    
    let paymentWaysInteractor = PaymentWaysInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navigationTitle
        
        paymentWaysInteractor.getUserID()
        //userID = paymentWaysInteractor.userID
        
        getPaymentData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        textPaymentOptions = [["Наличные", "Apple Pay"], ["Баллы"]]
        
        bgImageView.image = #imageLiteral(resourceName: "paymentWaysBG")
        
        linkCardButtonOutlet.alpha = 0

        
    }
    
    // MARK: - Methods
    
    //Задаем внешний вид кнопки Заказать такси
    private func setupTaxiOrderButton() {
        
        if textPaymentOptions[1].count == 1 {
            linkCardButtonOutlet.style()
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.blueColor.value
            linkCardButtonOutlet.setTitle(PaymentMainViewText.addButtonText.text(), for: .normal)
            linkCardButtonOutlet.alpha = 1
        } else {
            linkCardButtonOutlet.alpha = 0
        }
    }
    
    private func getPaymentData() {
        paymentWaysInteractor.loadPaymentData { modelsArray in
            
            DispatchQueue.main.async {
                self.paymentOptions = modelsArray
                self.createPaymentOptions()
                self.setupTaxiOrderButton()
                self.tableView.reloadData()
            }
        }
    }
    
    private func createPaymentOptions() {
        
        if paymentOptions.isEmpty {
            let bankCard = "Банковская карта"
            textPaymentOptions[0].insert(bankCard, at: 1)
        } else {
            for i in 0 ... paymentOptions.count - 1 {
                let index = i + 1
                textPaymentOptions[0].insert(paymentOptions[i].number, at: index)
            }
            let addCard = "Добавить карту"
            textPaymentOptions[1].insert(addCard, at: 0)
        }
    }
    
    private func setLefImage(for cell: PaymentWaysTableViewCell, section: Int, row: Int) {
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
                    break
                }
            }
        }
    }
    
    private func setRightImage(for cell: PaymentWaysTableViewCell, section: Int, row: Int) {
        if section == 0 {
            if paymentOptions.isEmpty {
                switch row {
                case 1:
                    cell.rightImageView.image = #imageLiteral(resourceName: "rightArrow")
                default :
                    cell.rightImageView.image = row == selectedCell ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
                }
            } else {
                cell.rightImageView.image = row == selectedCell ? #imageLiteral(resourceName: "selectedCheckBox") : #imageLiteral(resourceName: "emptyCheckBox")
            }
        } else {
            cell.rightImageView.image = #imageLiteral(resourceName: "rightArrow")
        }
    }
    

    
    // MARK: - Actions
    
    @IBAction func linkCardButtonAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
        //vc.titleNavigation = textPaymentOptions[indexPath.section][indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    


}

// MARK: - Extensions TableView Data Source

extension PaymentWaysViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return textPaymentOptions.isEmpty ? 1 : textPaymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textPaymentOptions.isEmpty ? 0 : textPaymentOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentWaysTableViewCell
        
        setLefImage(for: cell, section: indexPath.section, row: indexPath.row)
        
        if textPaymentOptions[1].count == 1 {
            cell.paymentTextLabel.text = textPaymentOptions[indexPath.section][indexPath.row]
        } else {
            switch indexPath.section {
            case 0:
                cell.paymentTextLabel.text = textPaymentOptions[indexPath.section][indexPath.row]
            case 1:
                if indexPath.row == 0 {
                    cell.paymentTextLabel.text = ""
                    cell.textLabel?.text = textPaymentOptions[indexPath.section][indexPath.row]
                } else {
                    cell.paymentTextLabel.text = textPaymentOptions[indexPath.section][indexPath.row]
                }
            default:
                break
            }
        }
        
        setRightImage(for: cell, section: indexPath.section, row: indexPath.row)
        

        return cell
    }
 
}

// MARK: - Extensions TableView Delegate

extension PaymentWaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let cellPreview = tableView.visibleCells[selectedCell] as! PaymentWaysTableViewCell
            let cellCurrent = tableView.visibleCells[indexPath.row] as! PaymentWaysTableViewCell
            
            if !paymentOptions.isEmpty {
                cellPreview.rightImageView.image = #imageLiteral(resourceName: "emptyCheckBox")
                cellCurrent.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
                selectedCell = indexPath.row
            } else {
                switch indexPath.row {
                case 1:
                    let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
                    //vc.titleNavigation = textPaymentOptions[indexPath.section][indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                default :
                    cellPreview.rightImageView.image = #imageLiteral(resourceName: "emptyCheckBox")
                    cellCurrent.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
                    selectedCell = indexPath.row
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
                //vc.titleNavigation = textPaymentOptions[indexPath.section][indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            default :
                print("???????")
            }
        }
            
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
}


