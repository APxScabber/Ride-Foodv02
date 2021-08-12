//
//  PaymentHistoryExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.08.2021.
//

import Foundation
import UIKit

// MARK: - Extensions TableView Data Source

extension PaymentHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentHistoryArray.isEmpty ? 0 : paymentHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentHistoryTableViewCell
        
        cell.selectionStyle = .none
        cell.serviceLabel.textColor = PaymentHistoryColors.grayColor.value
        cell.priceLabel.textColor = PaymentHistoryColors.grayColor.value
        cell.cardNumberLabel.text = ""
        
        let item = paymentHistoryArray[indexPath.row]
        
        cell.dateLabel.text = PaymentHistoryText.date.text()
        cell.serviceLabel.text = PaymentHistoryText.service.text()
        cell.paymentNumberLabel.text = PaymentHistoryText.orderNumber.text() + String(item.order)
        cell.priceLabel.text = String(item.paid) + PaymentHistoryText.price.text()
        
        paymentHistoryInteractor.setImage(for: cell, indexPath: indexPath, from: paymentHistoryArray)
        
        return cell
    }
}

// MARK: - Extensions TableView Delegate

extension PaymentHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedCell = tableView.cellForRow(at: indexPath) as? PaymentHistoryTableViewCell
        guard let selectedCell = selectedCell else { return }
        
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        
        mainInfoViewWidth = view.frame.width - 40
        mainInfoViewHeight = selectedCell.bgImage.frame.height - 20
        mainInfoViewPosY = rectOfCellInSuperview.origin.y + 10
        
        guard let mainInfoViewWidth = mainInfoViewWidth else { return }
        guard let mainInfoViewHeight = mainInfoViewHeight else { return }
        guard let mainInfoViewPosY = mainInfoViewPosY else { return }
        
        startUISetupMainInfoView(posY: mainInfoViewPosY,
                                 width: mainInfoViewWidth,
                                 height: mainInfoViewHeight)
        setBigViewData(for: selectedCell)
        mainInfoViewAnimationIn(cell: selectedCell)
    }
}
