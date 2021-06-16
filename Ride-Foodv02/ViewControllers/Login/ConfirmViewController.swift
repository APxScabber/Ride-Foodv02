//
//  ConfirmViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var mainCodeTextField: UITextField!
    @IBOutlet weak var textCodeConfirmLabel: UILabel!
    @IBOutlet var inputCodeLabel: [UILabel]!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var topButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    // MARK: - Properties

    var timer: Timer?
    
    var phoneNumber = ""
    var seconds = 30
    var inputLabelCount = 0

    var safeAreaTopHeigh: CGFloat = 0
    var topButtonConstraintHeight: CGFloat = 429
    var bottomButtonConstraintHeight: CGFloat = 70
    var isAnimationButton = false
    var keyboardHeight: CGFloat!
    
    let loginInteractor = LoginInteractor()
    let confirmInteractor = ConfirmInteracor()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextCodeConfirmTextField()
        setupInputCodeLabels()
        setupInfoTextView()
        setupNextButton()
        startCountDown()
        
        registerForKeyboardNotification()
    }
    
    deinit {
        print("Exit ConfirmVC")
    }
    
    // MARK: - Methods
    
    func errorAlertContoller(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: ConfirmText.alerButton.text(), style: .default) { [weak self] _ in
            self?.startCountDown()
            self?.mainCodeTextField.text = ""
            self?.startSetupView()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }

    //Задаем внешний вид лайблам под ввод кода подтвердения
    private func setupInputCodeLabels() {
        
        mainCodeTextField.becomeFirstResponder()
        
        for label in inputCodeLabel {
            label.style()
            label.textColor = LoginColors.blueColor.value
            label.font = UIFont(name: MainTextFont.main.rawValue, size: ConfirmFontSize.normal.rawValue)
            label.text = ""

            label.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "confirmEmpty"))
        }
    }
    
    //Задаем внешний вид кнопки Далее
    private func setupNextButton() {
        
        nextButtonOutlet.style()
        nextButtonOutlet.backgroundColor = LoginColors.greyButtonColor.value
        nextButtonOutlet.setTitle(ConfirmText.button.text(), for: .normal)
        nextButtonOutlet.isEnabled = false
    }
    
    //Сброс всех начтроек на начальные
    func startSetupView() {
        seconds = 30
        inputLabelCount = 0
        setupInputCodeLabels()
        setupNextButton()
        loginInteractor.reciveConfirmCode(from: phoneNumber)
    }
    
    //Задаем параметры загаловка окна
    private func setupTextCodeConfirmTextField() {
        textCodeConfirmLabel.text = ConfirmText.label.text()
        textCodeConfirmLabel.font = UIFont(
            name: MainTextFont.main.rawValue,
            size: LoginFontSize.normal.rawValue)
        textCodeConfirmLabel.textColor = LoginColors.blackTextColor.value
    }
    
//    // MARK: - Actions
//    
//    //Действие при воде кода в скрытый TextField (скрыт в Storyboard)
//    @IBAction func editingTextField(_ sender: UITextField) {
//        
//        guard let text = mainCodeTextField.text else { return }
//        
//        inputCodeLabel[inputLabelCount].backgroundColor = ColorElements.grayLableColor.value
//        
//        let index = text.index(text.startIndex, offsetBy: inputLabelCount)
//        inputCodeLabel[inputLabelCount].text = String(text[index])
//        
//        inputLabelCount += 1
//        
//        if inputLabelCount == 4 {
//            
//            nextButtonOutlet.isEnabled = true
//            nextButtonOutlet.backgroundColor = ColorElements.blueColor.value
//            mainCodeTextField.resignFirstResponder()
//            buttonAnimationOut()
//            scrollView.frame.origin.y = safeAreaTopHeigh
//        }
//    }
//    #warning("Что-то говорилось про вынос Action`ов куда-то. Уточнить")
    //класс статик функцию
    //Проверяем код подтверждения и либо обрабатываем ошибку либо переходим на Main Storyboard
//    @IBAction func nextButtonAction(_ sender: Any) {
//        
//        confirmInteractor.passConfirmationCode(phoneNumber: phoneNumber,
//                                               code: mainCodeTextField.text!) { [weak self] error in
//           
//            self?.timer?.invalidate()
//    
//            if error != nil {
//                self?.errorAlertContoller(title: ConfirmText.alertTitle.text(),
//                                          message: ConfirmText.alertMessage.text())
//            } else {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
//                vc.modalTransitionStyle = .coverVertical
//                vc.modalPresentationStyle = .overFullScreen
//                self?.present(vc, animated: true, completion: nil)
//            }
//        }
//    }
}
