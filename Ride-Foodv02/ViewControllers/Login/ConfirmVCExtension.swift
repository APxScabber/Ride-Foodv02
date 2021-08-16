//
//  ConfirmVCExtension.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.06.2021.
//

import Foundation
import UIKit

extension ConfirmViewController {

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
    
    //Таймер обратного отсчета, для повторной отправки кода подтверждения
    func startCountDown() {
    
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupInfoTextView), userInfo: nil, repeats: true)
    }
    
    //MARK: - Animation Methods
    
    //Анимация движения кнопки вверх
    func buttonAnimationIn(_ keyboardHeight: CGFloat) {
        
        if !isAnimationButton {
            isAnimationButton = true
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                
                self?.bottomButtonConstraint.constant += keyboardHeight - (self!.bottomButtonConstraintHeight/2)
                self?.view.layoutIfNeeded()
                self?.topButtonConstraint.constant = 5
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    //Анимация движения кнопки вниз
    func buttonAnimationOut() {

        if isAnimationButton {

            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in

                self?.topButtonConstraint.constant = self!.topButtonConstraintHeight
                self?.view.layoutIfNeeded()
                self?.bottomButtonConstraint.constant = self!.bottomButtonConstraintHeight
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

    //Метод по нажатию на экран
    @objc func screenTap() {
        
        mainCodeTextField.resignFirstResponder()
        
        if isAnimationButton {
            buttonAnimationOut()
        } else {
            scrollView.frame.origin.y = safeAreaTopHeigh
        }
    }
    
    //Метод формирующий внешний вид TextView с обратеым отсчетом, а также логика поведения при истечении времени
    @objc func setupInfoTextView() {
        
        if seconds < 0 {
            startSetupView()
        }

        let licenseText = confirmInteractor.separategText(phoneNumber: phoneNumber, seconds: seconds)
        let textCount = licenseText.count
        
        let typeTextAttribute: [NSAttributedString.Key : Any] = [.foregroundColor : LoginColors.blueColor.value]
        
            infoTextView.attributedText = createTextAttribute(inputText: licenseText, type: typeTextAttribute,
                                                                 locRus: textCount - 10, lenRus: 10,
                                                                 locEng: textCount - 10, lenEng: 10)
        
        infoTextView.textAlignment = .center
        
        let padding = infoTextView.textContainer.lineFragmentPadding
        infoTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        seconds -= 1
    }
}
