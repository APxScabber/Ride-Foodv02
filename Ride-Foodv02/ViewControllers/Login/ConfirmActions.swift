//
//  LoginActions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//

import Foundation
import UIKit

extension ConfirmViewController {
    
    // MARK: - Actions
    
    //Действие при воде кода в скрытый TextField (скрыт в Storyboard)
    @IBAction func editingTextField(_ sender: UITextField) {
        
        guard let text = mainCodeTextField.text else { return }
        
        if text.count == inputLabelCount + 1 {
            
            inputCodeLabel[inputLabelCount].backgroundColor = LoginColors.grayLableColor.value
            
            let index = text.index(text.startIndex, offsetBy: inputLabelCount)
            inputCodeLabel[inputLabelCount].text = String(text[index])
            
            inputLabelCount += 1
            
            if inputLabelCount == 4 {
                
                nextButtonOutlet.isEnabled = true
                nextButtonOutlet.backgroundColor = LoginColors.blueColor.value
                mainCodeTextField.resignFirstResponder()
                buttonAnimationOut()
                scrollView.frame.origin.y = safeAreaTopHeigh
            }
        } else {
            inputLabelCount -= 1
            inputCodeLabel[inputLabelCount].backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "confirmEmpty"))
            inputCodeLabel[inputLabelCount].text = ""
            
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        confirmInteractor.passConfirmationCode(phoneNumber: phoneNumber,
                                               code: mainCodeTextField.text!) { [weak self] error in
           
            self?.timer?.invalidate()
    
            if error != nil {
                self?.errorAlertContoller(title: ConfirmText.alertTitle.text(),
                                          message: ConfirmText.alertMessage.text())
            } else {
                let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainScreenViewController
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
