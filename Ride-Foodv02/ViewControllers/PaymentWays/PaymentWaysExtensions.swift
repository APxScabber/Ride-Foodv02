//
//  PaymentWaysExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.08.2021.
//

import Foundation
import UIKit

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
        
        cell.paymentTextLabel.text = ""
        cell.textLabel?.text = ""
        setLefImage(for: cell, section: indexPath.section, row: indexPath.row)
        
        if textPaymentOptions[1].count == 1 {
            cell.paymentTextLabel.text = textPaymentOptions[indexPath.section][indexPath.row]
        } else {
            switch indexPath.section {
            case 0:
                let inputText = textPaymentOptions[indexPath.section][indexPath.row]
                if paymentWaysInteractor.filter(text: inputText) {
                    let formatedCardNumber = PaymentMainViewText.cardNumber.text() + " " + inputText.suffix(4)
                    let typeAttributeText: [NSAttributedString.Key : Any] = [ .foregroundColor : PaymentWaysColors.grayColor.value]
                    let finallText = createTextAttribute(inputText: formatedCardNumber, type: typeAttributeText,
                                                            locRus: 6, lenRus: 9,
                                                            locEng: 5, lenEng: 9)
                    cell.paymentTextLabel.attributedText = finallText
                } else {
                    cell.paymentTextLabel.text = inputText
                }

            case 1:
                if indexPath.row == 0 {
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
        
        var cellPreview: PaymentWaysTableViewCell?
        
        if indexPath.section == 0 {

            if let selectedCell = selectedCell {
                cellPreview = tableView.cellForRow(at: selectedCell) as? PaymentWaysTableViewCell
            }
            let cellCurrent = tableView.cellForRow(at: indexPath) as! PaymentWaysTableViewCell
            
            if !paymentOptions.isEmpty {
                CurrentPayment.shared.id = indexPath.row
                if let cellPreview = cellPreview {
                    cellPreview.rightImageView.image = #imageLiteral(resourceName: "emptyCheckBox")
                }
                cellCurrent.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
                selectedCell = indexPath
            } else {
                switch indexPath.row {
                case 1:
                    let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
                    navigationController?.pushViewController(vc, animated: true)
                default :
                    if let cellPreview = cellPreview {
                        cellPreview.rightImageView.image = #imageLiteral(resourceName: "emptyCheckBox")
                    }
                    cellCurrent.rightImageView.image = #imageLiteral(resourceName: "selectedCheckBox")
                    selectedCell = indexPath
                }
            }
        } else {
            
            if textPaymentOptions[1].count == 1 {
                let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TotalScores") as! TotalScoreViewController
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else {
                switch indexPath.row {
                case 0:
                    let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AddCard") as! AddCardViewController
                    navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "TotalScores") as! TotalScoreViewController
                    vc.modalPresentationStyle = .formSheet
                    present(vc, animated: true, completion: nil)
                default :
                    print("???????")
                }
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
}
