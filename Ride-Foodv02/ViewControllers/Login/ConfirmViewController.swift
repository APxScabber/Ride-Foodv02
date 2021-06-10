//
//  ConfirmViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var mainCodeTextField: UITextField!
    @IBOutlet weak var textCodeConfirmLabel: UILabel!
    @IBOutlet var inputCodeLabel: [UILabel]!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Setup Values

    private var timer: Timer?
    
    var phoneNumber = ""
    private var seconds = 30
    private var inputLabelCount = 0
    
    private var startColorLocation: Int!
    private var colorLenght: Int!
    
    var languageCode = LoginViewController().languageCode
    //var languageCode = Language.russian.code
    
    let loginInteractor = LoginInteractor()
    let confirmInteractor = ConfirmInteracor()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextCodeConfirmTextField()
        setupInputCodeLabels()
        setupInfoTextView()
        setupNextButton()
        
        registerForKeyboardNotification()
        
        startCountDown()
    }
    
    deinit {
        print("Exit ConfirmVC")
    }
    
    //MARK: - Methods
    
    private func errorAlertContoller(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: Language(languageCode)?.alertButton, style: .default) { [weak self] _ in
            self?.startCountDown()
            self?.mainCodeTextField.text = ""
            self?.startSetupView()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    #warning("Повторяющийся метод, такой же испльзуется в LoginVC")
    //Регистрируем уведомления на пояаление и скрытие клавиатуры
    private func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //Таймер обратного отсчета, для повторной отправки кода подтверждения
    private func startCountDown() {
    
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupInfoTextView), userInfo: nil, repeats: true)
    }

    #warning("на лейблах непонятные кресты")
    //Задаем внешний вид лайблам под ввод кода подтвердения
    private func setupInputCodeLabels() {
        
        mainCodeTextField.becomeFirstResponder()
        
        for label in inputCodeLabel {
            label.textColor = ColorElements.blueColor.value
            label.font = UIFont(name: TextFont.main.rawValue, size: ConfirmFontSize.normal.rawValue)
            label.text = ""
            label.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "confirmEmpty"))
        }
    }
    
    //Задаем внешний вид кнопки Далее
    private func setupNextButton() {
        
        nextButtonOutlet.style()
        nextButtonOutlet.backgroundColor = ColorElements.greyButtonColor.value
        nextButtonOutlet.setTitle(Language(languageCode)?.buttonText, for: .normal)
        nextButtonOutlet.isEnabled = false
    }
    
    //Сброс всех начтроек на начальные
    private func startSetupView() {
        seconds = 30
        inputLabelCount = 0
        setupInputCodeLabels()
        setupNextButton()
        loginInteractor.reciveConfirmCode(from: phoneNumber)
    }
    
    //Задаем параметры загаловка окна
    private func setupTextCodeConfirmTextField() {
        textCodeConfirmLabel.text = Language(languageCode)?.textCodeConfirmLabel
        textCodeConfirmLabel.font = UIFont(
            name: TextFont.main.rawValue,
            size: LoginFontSize.normal.rawValue)
        textCodeConfirmLabel.textColor = ColorElements.blackTextColor.value
    }
    
    //Создаем распознавание жестов касанием
    private func registrationTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(screenTap))
        view.addGestureRecognizer(gesture)
    }
    
    //MARK: - @objc Methods
    
    @objc func screenTap() {
       mainCodeTextField.becomeFirstResponder()
    }
    
    //Метод формирующий внешний вид TextView с обратеым отсчетом, а также логика поведения при истечении времени
    @objc func setupInfoTextView() {
        
        if seconds < 0 {
            startSetupView()
        }
        
        let text = Language(languageCode)!.infoTextView
        let textArray = text.components(separatedBy: "@#^")

        let licenseText = textArray[0] + phoneNumber + textArray[1] + String(seconds) + textArray[2]
        let textCount = licenseText.count
        
        #warning("Подумать как реализовать лучше, без цифр")
        switch Language(languageCode) {
        case .russian:
            startColorLocation = textCount - 10
            colorLenght = 10
            
            if textCount == 85 {
                startColorLocation = textCount - 9
                colorLenght = 9
            }
        case .english:
            startColorLocation = textCount - 10
            colorLenght = 10
            
            if textCount == 75 {
                startColorLocation = textCount - 9
                colorLenght = 8
            }
        case .none:
            return
        }

        let attributedString = NSMutableAttributedString(string: licenseText)

        attributedString.addAttributes([ .foregroundColor : ColorElements.blueColor.value], range: NSRange(location: startColorLocation, length: colorLenght))
        attributedString.addAttribute(.foregroundColor, value: ColorElements.grayTextColor.value, range: NSRange(location: 0, length: startColorLocation))

        infoTextView.attributedText = attributedString
        
        infoTextView.textAlignment = .center
        
        let padding = infoTextView.textContainer.lineFragmentPadding
        infoTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        seconds -= 1
    }
    
    #warning("Некорректно работает, при загрузке контроллера дергается вверх и возвращается назад")
    #warning("Повторяющийся метод, такой же испльзуется в LoginVC")
    //Метод отрабатывающий появление клавиатуры
    @objc func keyboardWillShow(_ notification: Notification) {
        
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
    
    #warning("Повторяющийся метод, такой же испльзуется в LoginVC")
    //Метод отрабатывающий скрытие клавиатуры
    @objc func keyboardWillHide(_ notification: Notification) {
       scrollView.frame.origin.y = .zero
    }
    
    //MARK: - Actions
    
    //Действие при воде кода в скрытый TextField (скрыт в Storyboard)
    @IBAction func editingTextField(_ sender: UITextField) {
        
        guard let text = mainCodeTextField.text else { return }
        
        inputCodeLabel[inputLabelCount].backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "checkBtnOff"))
        let index = text.index(text.startIndex, offsetBy: inputLabelCount)
        inputCodeLabel[inputLabelCount].text = String(text[index])
        
        inputLabelCount += 1
        
        if inputLabelCount == 4 {
            mainCodeTextField.resignFirstResponder()
            nextButtonOutlet.isEnabled = true
            nextButtonOutlet.backgroundColor = ColorElements.blueColor.value
        }
    }
    
    //Проверяем код подтверждения и либо обрабатываем ошибку либо переходим на Main Storyboard
    @IBAction func nextButtonAction(_ sender: Any) {
        
        confirmInteractor.passConfirmationCode(phoneNumber: phoneNumber,
                                               code: mainCodeTextField.text!) { [weak self] error in
           
            self?.timer?.invalidate()
    
            if error != nil {
                self?.errorAlertContoller(title: Language(self?.languageCode)!.alertTitle,
                                          message: Language(self?.languageCode)!.alertMessage)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
