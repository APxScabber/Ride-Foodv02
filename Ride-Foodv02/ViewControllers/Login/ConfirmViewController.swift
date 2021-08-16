//
//  ConfirmViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class ConfirmViewController: BaseViewController {
    
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
            label.font = UIFont(name: TextFont.main.rawValue, size: ConfirmFontSize.normal.rawValue)
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
            name: TextFont.main.rawValue,
            size: LoginFontSize.normal.rawValue)
        textCodeConfirmLabel.textColor = LoginColors.blackTextColor.value
    }
}
