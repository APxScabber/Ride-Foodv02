//
//  LoginViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var licenseCheckBoxOutlet: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var bottomButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topButtomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let maxLenghtPhoneNumber = 19
    let minLenghtPhoneNumber = 1
    var isPhoneNumberCorrect = false
    var isLicenseAccept = false
    
    var safeAreaTopHeigh: CGFloat = 0
    var topButtonConstraintHeight: CGFloat = 304
    var bottomButtonConstraintHeight: CGFloat = 70
    var isAnimationButton = false
    var keyboardHeight: CGFloat!
    
    let loginInteractor = LoginInteractor()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

            setupPhoneNumberLabel()
            setupNextButton()
            setImageLicenseCheckBox()
            setupLicenseTextView()
            
            phoneNumberTextField.text = ConstantText.phonePrefix.rawValue

            registerForKeyboardNotification()
            registrationTapGesture()
    }

    deinit {
        print("exit LoginVC")
    }
    
    // MARK: - Methods
    
    //Делаем кнопку Далее активной или неактивной
    func isNextButtonEnable() {
        if isLicenseAccept && isPhoneNumberCorrect {
            nextButtonOutlet.isEnabled = true
            nextButtonOutlet.backgroundColor = LoginColors.blueColor.value
        } else {
            nextButtonOutlet.isEnabled = false
            nextButtonOutlet.backgroundColor = LoginColors.greyButtonColor.value
        }
    }
    
    //Устанавливаем картинку на кнопку принятия Пользовательского соглашения
    func setImageLicenseCheckBox() {
        if !isLicenseAccept {
            licenseCheckBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBtnOff"), for: .normal)
        } else {
            licenseCheckBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBtnOn"), for: .normal)
        }
    }

    //Создаем гиперссылку на фразу "Пользовательское соглащение"
    private func setupLicenseTextView() {

        textView.attributedText = loginInteractor.createTextAttribute()
        textView.textColor = LoginColors.grayTextColor.value
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    //Задаем параметры и текст кнопке
    private func setupNextButton() {
        nextButtonOutlet.style()
        isNextButtonEnable()
        nextButtonOutlet.setTitle(LoginText.buttonText.text(), for: .normal)
    }
    
    //Задаем параметры и текст phoneNumberLabel
    private func setupPhoneNumberLabel() {
        phoneNumberLabel.text = LoginText.phoneNumberLable.text()
        phoneNumberLabel.font = UIFont(
            name: MainTextFont.main.rawValue,
            size: LoginFontSize.normal.rawValue)
        phoneNumberLabel.textColor = LoginColors.blackTextColor.value
    }
}

