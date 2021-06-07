//
//  LoginViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var licenseCheckBoxOutlet: UIButton!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    //MARK: - Setup Values
    
    private let maxLenghtPhoneNumber = 19
    private let minLenghtPhoneNumber = 1
    private var isPhoneNumberCorrect = false
    private var isLicenseAccept = false
    
    let loginInteractor = LoginInteractor()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPhoneNumberLabel()
        mainImageView.image = LoginImages.mainBackground.value
        setupNextButton()
        setImageLicenseCheckBox()
        setupLicenseTextView()

        phoneNumberTextField.text = LoginText.phonePrefix.rawValue
        
    }
    
    deinit {
        print("exit")
    }
    
    //MARK: - Methods
    
    //Задаем параметры и текст phoneNumberLabel
    private func setupPhoneNumberLabel() {
        phoneNumberLabel.text = LoginText.phoneNumberLable.rawValue
        phoneNumberLabel.font = UIFont(
            name: TextFont.main.rawValue,
            size: LoginFontSize.normal.rawValue)
        phoneNumberLabel.textColor = ColorElements.blackTextColor.value
    }
    
    //Задаем параметры и текст кнопке
    private func setupNextButton() {
        nextButtonOutlet.style()
        isNextButtonEnable()
        nextButtonOutlet.setTitle(LoginText.buttonText.rawValue, for: .normal)
    }
    
    //Создаем гиперссылку на фразу "Пользовательское соглащение"
    private func setupLicenseTextView() {
        
        let licenseText = LoginText.licenseInfo.rawValue
        
        let attributedString = NSMutableAttributedString(string: licenseText)
        attributedString.addAttribute(.link, value: LoginText.licenseLink.rawValue,
                                      range: NSRange(location: 49, length: 28))
        
        textView.attributedText = attributedString
        textView.textColor = ColorElements.grayTextColor.value
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    //Устанавливаем картинку на кнопку принятия Пользовательского соглашения
    private func setImageLicenseCheckBox() {
        if !isLicenseAccept {
            licenseCheckBoxOutlet.setBackgroundImage(LoginImages.checkBoxDisable.value, for: .normal)
        } else {
            licenseCheckBoxOutlet.setBackgroundImage(LoginImages.checkBoxEnable.value, for: .normal)
        }
    }
    
    //Делаем кнопку Далее активной или неактивной
    private func isNextButtonEnable() {
        if isLicenseAccept && isPhoneNumberCorrect {
            nextButtonOutlet.isEnabled = true
            nextButtonOutlet.backgroundColor = ColorElements.buttonEnableColor.value
        } else {
            nextButtonOutlet.isEnabled = false
            nextButtonOutlet.backgroundColor = ColorElements.buttonDisableColor.value
        }
    }
    
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
            
        case minLenghtPhoneNumber:
            sender.text = LoginText.phonePrefix.rawValue
            
        default:
            let formatedNumber = sender.text!
                .applyPatternOnNumbers(pattern:
                                        LoginText.phoneFormatFull.rawValue,
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

