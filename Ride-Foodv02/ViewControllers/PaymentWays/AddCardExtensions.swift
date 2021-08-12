//
//  AddCardExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.08.2021.
//

import Foundation
import UIKit

// MARK: - Extensions

extension AddCardViewController {

    // MARK: - Add Card Methods
    
    func formated(textField: UITextField, max: Int, pattern: String) -> String {
        
        guard var text = textField.text else { return "" }
        
        switch text.count {
        case max:
            textField.deleteBackward()
            text = textField.text!
        default:
            let formatedCardNumber = textField.text?
                .applyPatternOnNumbers(pattern: pattern, replacmentCharacter: "#")
            textField.text = formatedCardNumber
        }
        
        return textField.tag == 1 ? text : text.applyPatternOnNumbers(pattern: ConstantText.normalNumberFormat.rawValue,
                                          replacmentCharacter: "#")
    }
    
    func checkAllCardFields() {
        
        if isCardNumberFull && isCardDateFull && isCardCVVFull {
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.blueColor.value
            setupUnderLinesBlueColor()
            linkCardButtonOutlet.isEnabled = true
        } else {
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.grayColor.value
            setupUnderLinesGrayColor()
            linkCardButtonOutlet.isEnabled = false
        }
    }
    
    // MARK: - Add Card Actions
    
    @IBAction func cardNumberTextFieldAction(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }
        
        cardNumber = formated(textField: sender, max: 20, pattern: ConstantText.cardNumber.rawValue)
        
        if count >= 19 {
            cardDateTextField.becomeFirstResponder()
            isCardNumberFull = true
        } else {
            isCardNumberFull = false
        }
        
        if count > 4 {
            cardImageView.image = #imageLiteral(resourceName: "Visa")
        } else {
            cardImageView.image = nil
        }
        
        checkAllCardFields()
    }
    
    @IBAction func cardDateTextFieldAction(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }
        
        cardDate = formated(textField: sender, max: 6, pattern: ConstantText.cardDate.rawValue)
        
        if count >= 5 {
            cardCVVTextField.becomeFirstResponder()
            isCardDateFull = true
        } else {
            isCardDateFull = false
        }
        
        checkAllCardFields()
    }
    
    @IBAction func cardCVVTextFieldAction(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }
        
        cardCVV = formated(textField: sender, max: 4, pattern: ConstantText.cardCVV.rawValue)
        
        if count >= 3 {
            isCardCVVFull = true
        } else {
            isCardCVVFull = false
        }
        
        checkAllCardFields()
        
    }
    
    @IBAction func linkCardButtonAction(_ sender: Any) {

        inputCardNumber = cardNumber
        
        UIView.animate(withDuration: 1.5) {

            self.addCardView.frame.origin.y = self.view.frame.height

            self.cardCVVTextField.resignFirstResponder()
            self.cardNumberTextField.resignFirstResponder()
            self.cardDateTextField.resignFirstResponder()

        } completion: { _ in
            
            let passData = ["number" : self.cardNumber, "expiry_date" : self.cardDate, "cvc" : self.cardCVV]
            
            self.addCardInteractor.postCardData(passData: passData) { model in
                self.cardID = model?.id
            }
            
            self.addCardView.removeFromSuperview()
        }
    }
}

extension AddCardViewController {
    
    @IBAction func confirmButtonAction(_ sender: Int) {
      
        UIView.animate(withDuration: 1.5) {
            
            self.cardConfirmView.frame.origin.y = self.view.frame.height
            
            if let cardID = self.cardID {
                self.addCardInteractor.approvedCard(with: cardID)
            }
            
        } completion: { _ in
            
            //self.animationAddScores()
            self.navigationController?.popViewController(animated: true)
            self.cardConfirmView.removeFromSuperview()
            
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        cardConfirmView.removeFromSuperview()
    }
}

