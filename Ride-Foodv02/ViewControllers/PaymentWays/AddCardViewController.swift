//
//  AddCardViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 04.07.2021.
//

import UIKit

class AddCardViewController: BaseViewController {
    
    // MARK: - Outlets
    
    // Outlets для Main Screen
    @IBOutlet weak var hideTextField: UITextField!
    @IBOutlet weak var bgImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgImageView: UIImageView!
    
    // Outlets для Add Card View
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardDateTextField: UITextField!
    @IBOutlet weak var cardCVVTextField: UITextField!
    @IBOutlet weak var linkCardButtonOutlet: UIButton!
    @IBOutlet var underLinesArray: [UIButton]!
    
    // Outlets для Confirm Card View
    @IBOutlet weak var cardConfirmView: UIView!
    @IBOutlet weak var confirmTitleTextView: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!

    // MARK: - Properties
    var titleNavigation = AddCardViewText.newCard.text()
    
    var keyboardHeight: CGFloat?
    
    var cardNumber = ""
    var cardDate = ""
    var cardCVV = ""
    
    var isCardNumberFull = false
    var isCardDateFull = false
    var isCardCVVFull = false
    
    var inputCardNumber: String?
    var cardID: Int?
    
    let addCardInteractor = AddCardInteractor()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserID()
        
        navigationItem.title = titleNavigation
        registerForKeyboardNotification()
        bgImageTopConstraint.constant = view.frame.height / 2
        setupUnderLinesGrayColor()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideTextField.becomeFirstResponder()
        setupAddCardView()
        setupAddCardConfirmView()

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            self.animationAddCard()
        }
    }
    //MARK: - Dismiss
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    private func setupAddCardView() {
        addCardView.frame.size = CGSize(width: view.frame.width, height: 215)
        addCardView.frame.origin.y = view.frame.height - addCardView.frame.height
            
        addCardView.layer.cornerRadius = view.frame.width / 16
        addCardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        addCardView.layer.shadowColor = UIColor.black.cgColor
        addCardView.layer.shadowOpacity = 1
        addCardView.layer.shadowOffset = .zero
        addCardView.layer.shadowRadius = 10
        
        cardNumberTextField.placeholder = AddCardViewText.cardNumberTF.text()
        cardDateTextField.placeholder = AddCardViewText.cardDateTF.text()
        cardCVVTextField.placeholder = AddCardViewText.cardCVVTF.text()
            
        linkCardButtonOutlet.style()
        linkCardButtonOutlet.backgroundColor = TariffsColors.grayButtonColor.value
        linkCardButtonOutlet.setTitle(PaymentMainViewText.addButtonText.text(), for: .normal)
        linkCardButtonOutlet.isEnabled = false
    }
    
    private func setupAddCardConfirmView() {
        cardConfirmView.frame.size = CGSize(width: view.frame.width, height: 265)
        cardConfirmView.frame.origin.y = view.frame.height

        cardConfirmView.layer.cornerRadius = view.frame.width / 16
        cardConfirmView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        cardConfirmView.layer.shadowColor = UIColor.black.cgColor
        cardConfirmView.layer.shadowOpacity = 1
        cardConfirmView.layer.shadowOffset = .zero
        cardConfirmView.layer.shadowRadius = 10
        
        confirmTitleTextView.text = ConfirmCardViewText.confirm.text()

        confirmButtonOutlet.style()
        confirmButtonOutlet.backgroundColor = TariffsColors.blueColor.value
        confirmButtonOutlet.setTitle(ConfirmCardViewText.confirmButtonText.text(), for: .normal)
        cancelButtonOutlet.setTitle(ConfirmCardViewText.cancelButtonText.text(), for: .normal)
        
    }
    
    func setupUnderLinesGrayColor() {
        for line in underLinesArray {
            line.tintColor = PaymentWaysColors.grayColor.value
        }
    }
    
    func setupUnderLinesBlueColor() {
        for line in underLinesArray {
            line.tintColor = PaymentWaysColors.blueColor.value
        }
    }
    
    private func animationAddCard() {
        
        UIView.animate(withDuration: 2) {
            if let keyboardHeight = self.keyboardHeight {
                
                self.view.addSubview(self.addCardView)
                self.addCardView?.frame.origin.y = self.view.frame.height - keyboardHeight - self.addCardView!.frame.height
                
                self.bgImageTopConstraint.constant = 10
                self.view.superview?.layoutIfNeeded()
            }
        } completion: { _ in
            self.cardNumberTextField.becomeFirstResponder()
        }
    }
    
    private func animationAddCardConfirm() {
        
        if let cardNumber = inputCardNumber {
            let finalText = addCardInteractor.createShortCardNumber(text: cardNumber)
            var typeAttributeText = [NSAttributedString.Key : Any]()
            if let font = UIFont.SFUIDisplayBold(size: 12) {
                typeAttributeText = [ .font : font]
            } else {
                typeAttributeText = [.font : UIFont(name: "Symbol", size: 12)!]
            }
            
            let textAttribute = createTextAttribute(inputText: finalText, type: typeAttributeText,
                                                       locRus: 45, lenRus: 9,
                                                       locEng: 61, lenEng: 9)
            infoTextView.attributedText = textAttribute
        } else {
            infoTextView.text = addCardInteractor.createShortCardNumber(text: "")
        }

        UIView.animate(withDuration: 2) {
            self.view.addSubview(self.cardConfirmView)
            self.cardConfirmView?.frame.origin.y = self.view.frame.height - self.cardConfirmView!.frame.height

            self.bgImageTopConstraint.constant = 80
            self.view.superview?.layoutIfNeeded()
        }
    }

    //Регистрируем уведомления на пояаление клавиатуры
    func registerForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        animationAddCardConfirm()
    }
}
