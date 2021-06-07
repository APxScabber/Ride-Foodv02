//
//  LoginViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    
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
        
        nextButtonOutlet.style()
        setupLicenseTextView()
        phoneNumberTextField.text = "+7"
        setImageLicenseCheckBox()
        nextButtonEnable()
    }
    
    deinit {
        print("exit")
    }
    
    //MARK: - Methods
    
    //Создаем гиперссылку на фразу "Пользовательское соглащение"
    private func setupLicenseTextView() {
        
        let licenseText = "Даю согласие на обработку персональных данных, с пользовательским соглашением ознакомлен"
        
        let attributedString = NSMutableAttributedString(string: licenseText)
        attributedString.addAttribute(.link, value: "https://www.google.com/", range: NSRange(location: 49, length: 28))
        
        textView.attributedText = attributedString
        textView.textColor = .systemGray
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    //Устанавливаем картинку на кнопку принятия Пользовательского соглашения
    private func setImageLicenseCheckBox() {
        if !isLicenseAccept {
            licenseCheckBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBtnOff"), for: .normal)
        } else {
            licenseCheckBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBtnOn"), for: .normal)
        }
    }
    
    //Делаем кнопку Далее активной или неактивной
    private func nextButtonEnable() {
        if isLicenseAccept && isPhoneNumberCorrect {
            nextButtonOutlet.isEnabled = true
            nextButtonOutlet.backgroundColor = #colorLiteral(red: 0.3084548712, green: 0.352679342, blue: 1, alpha: 1)
        } else {
            nextButtonOutlet.isEnabled = false
            nextButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    // MARK: - Actions
    
    //Действие при нажатии на кнопку принятия Пользовательского соглашения
    @IBAction func acceptLicenseButton(_ sender: Any) {
        isLicenseAccept = !isLicenseAccept
        setImageLicenseCheckBox()
        nextButtonEnable()
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
            sender.text = "+7"
            
        default:
            let formatedNumber = sender.text!
                .applyPatternOnNumbers(pattern:
                                        "+# (###) ###-##-##",
                                       replacmentCharacter: "#")
            isPhoneNumberCorrect = false
            sender.text = formatedNumber
        }
        
        nextButtonEnable()
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

