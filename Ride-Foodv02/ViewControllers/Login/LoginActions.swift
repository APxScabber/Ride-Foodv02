//
//  LoginActions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//

import Foundation
import UIKit

extension LoginViewController {
    
    // MARK: - Actions
    
    //Действие при нажатии на кнопку принятия Пользовательского соглашения
    @IBAction func acceptLicenseButton(_ sender: Any) {
        isLicenseAccept = !isLicenseAccept
        setImageLicenseCheckBox()
        isNextButtonEnable()
    }
    
    //Проверяем корректность формата вводимого номера телефона
    @IBAction func checkPhoneNumberTextField(_ sender: UITextField) {

        let count = sender.text!.count
        
        switch count {
        
        case maxLenghtPhoneNumber:
            sender.deleteBackward()
            isPhoneNumberCorrect = true
            
        case maxLenghtPhoneNumber - 1:
            isPhoneNumberCorrect = true
            phoneNumberTextField.resignFirstResponder()
            buttonAnimationOut()
            scrollView.frame.origin.y = safeAreaTopHeigh
            
        case minLenghtPhoneNumber:
            sender.text = LoginConstantText.phonePrefix.rawValue
            
        default:
            let formatedNumber = sender.text!
                .applyPatternOnNumbers(pattern:
                                        LoginConstantText.phoneFormatFull.rawValue,
                                       replacmentCharacter: "#")
            isPhoneNumberCorrect = false
            sender.text = formatedNumber
        }
        
        isNextButtonEnable()
    }
    
    //Действие при нажатии на кнопку Далее
    @IBAction func nextButton(_ sender: Any) {
        loginInteractor.reciveConfirmCode(from: phoneNumberTextField.text!)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toConfirmVC" else { return }
        guard let destination = segue.destination as? ConfirmViewController else { return }

        destination.phoneNumber = phoneNumberTextField.text!
    }
}
