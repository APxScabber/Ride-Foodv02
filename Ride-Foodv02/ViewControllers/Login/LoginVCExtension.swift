//
//  LoginVCExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

extension LoginViewController: UITextViewDelegate {

    // MARK: - Delegate Methods
    
    //Для активации гиперссылки
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    // MARK: - Methods
    
    //Регистрируем уведомления на пояаление клавиатуры
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    //Создаем распознавание жестов касанием
    func registrationTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(screenTap))
        view.addGestureRecognizer(gesture)
    }
    
    //MARK: - Animation Methods
    
    //Анимация движения кнопки вверх
    func buttonAnimationIn(_ keyboardHeight: CGFloat) {
        
        if !isAnimationButton {
            isAnimationButton = true
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                
                self?.bottomButtomConstraint.constant += keyboardHeight - (self!.bottomButtonConstraintHeight/2)
                self?.view.layoutIfNeeded()
                self?.topButtomConstraint.constant = 5
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    //Анимация движения кнопки вниз
    func buttonAnimationOut() {

        if isAnimationButton {

            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in

                self?.topButtomConstraint.constant = 150.0
                self?.view.layoutIfNeeded()
                self?.bottomButtomConstraint.constant = self!.bottomButtonConstraintHeight
                self?.view.layoutIfNeeded()
                self?.isAnimationButton = false
            })
        }
    }
    
    //MARK: - @objc Methods
    
    //Метод отрабатывающий появление клавиатуры
    @objc func keyboardWillShow(_ notification: Notification) {

        //Получаем высоту верхнего Safe Area
        let window = view.window
        safeAreaTopHeigh = (window?.safeAreaInsets.top)!

        keyboardHeight = loginInteractor.getKeyboardHeight(notification)

        var aRect: CGRect = view.frame
        aRect.size.height -= keyboardHeight

        if let activeField = stackView {
            if  aRect.contains(activeField.frame.origin) {
                
                buttonAnimationIn(keyboardHeight)
            } else {
                scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
            }
        }
    }
    
    //По нажатию на экран клавиатура убирается
    @objc func screenTap() {
        
        phoneNumberTextField.resignFirstResponder()
 
        if isAnimationButton {
            buttonAnimationOut()
        } else {
          //  scrollView.frame.origin.y = safeAreaTopHeigh
        }
    }
}
