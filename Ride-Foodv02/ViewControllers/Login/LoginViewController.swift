//
//  LoginViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var licenseCheckBoxOutlet: UIButton!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    //MARK: - Setup Values
    
    private let maxLenghtPhoneNumber = 19
    private let minLenghtPhoneNumber = 1
    private var isPhoneNumberCorrect = false
    private var isLicenseAccept = false
    
    #warning("Эту переменную хранить например в UserDefaults")
    var languageCode = Language.russian.code
    
    let loginInteractor = LoginInteractor()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPhoneNumberLabel()
        setupNextButton()
        setImageLicenseCheckBox()
        setupLicenseTextView()

        phoneNumberTextField.text = LoginText.phonePrefix.rawValue

        registerForKeyboardNotification()
        registrationTapGesture()
    }
    
    deinit {
        print("exit")
    }
    
    //MARK: - Methods
    
    //Регистрируем уведомления на пояаление и скрытие клавиатуры
    private func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //Создаем распознавание жестов касанием
    private func registrationTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(screenTap))
        view.addGestureRecognizer(gesture)
    }

    //Задаем параметры и текст phoneNumberLabel
    private func setupPhoneNumberLabel() {
        phoneNumberLabel.text = Language(languageCode)?.phoneNumberLable
        phoneNumberLabel.font = UIFont(
            name: TextFont.main.rawValue,
            size: LoginFontSize.normal.rawValue)
        phoneNumberLabel.textColor = ColorElements.blackTextColor.value
    }
    
    //Задаем параметры и текст кнопке
    private func setupNextButton() {
        nextButtonOutlet.style()
        isNextButtonEnable()
        nextButtonOutlet.setTitle(Language(languageCode)?.buttonText, for: .normal)
    }
    
    //Создаем гиперссылку на фразу "Пользовательское соглащение"
    private func setupLicenseTextView() {
        
        let licenseText = Language(languageCode)!.licenseInfo
        
        let attributedString = NSMutableAttributedString(string: licenseText)
        
        switch Language(languageCode) {
        case .russian:
            attributedString.addAttribute(.link, value: LoginText.licenseLink.rawValue,
                                          range: NSRange(location: 49, length: 28))
        case .english:
            attributedString.addAttribute(.link, value: LoginText.licenseLink.rawValue,
                                          range: NSRange(location: 60, length: 14))
        case .none:
            return
        }

        textView.attributedText = attributedString
        textView.textColor = ColorElements.grayTextColor.value
        
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
    private func isNextButtonEnable() {
        if isLicenseAccept && isPhoneNumberCorrect {
            nextButtonOutlet.isEnabled = true
            nextButtonOutlet.backgroundColor = ColorElements.blueColor.value
        } else {
            nextButtonOutlet.isEnabled = false
            nextButtonOutlet.backgroundColor = ColorElements.greyButtonColor.value
        }
    }
    
    //MARK: - @objc Methods
    
    #warning("Некорректно работает, если на клавиатуре ввести символ, то scrollView опускается")
    //Метод отрабатывающий появление клавиатуры
    @objc func keyBoardWillShow(_ notification: Notification) {
        
        let keyboardHeight = loginInteractor.getKeyboardHeight(notification)
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardHeight
        if let activeField = self.nextButtonOutlet {
            if (!aRect.contains(activeField.frame.origin)) {
                
                self.scrollView.frame.origin.y = -keyboardHeight + 1.5 * activeField.frame.size.height
                //self.scrollView.contentOffset.y = -keyboardHeight + 1.5 * activeField.frame.size.height
                
            }
        }
    }
    
    //Метод отрабатывающий скрытие клавиатуры
    @objc func keyBoardWillHide(_ notification: Notification) {
       scrollView.frame.origin.y = .zero
    }
    
    @objc func screenTap() {
       phoneNumberTextField.resignFirstResponder()
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
            phoneNumberTextField.resignFirstResponder()
            
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

