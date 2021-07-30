//
//  AddCardViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 04.07.2021.
//

import UIKit

class AddCardViewController: UIViewController {
    
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
    var titleNavigation = "Новая карта"
    
    var keyboardHeight: CGFloat?
    
    var cardNumber = ""
    var cardDate = ""
    var cardCVV = ""
    
    var isCardNumberFull = false
    var isCardDateFull = false
    var isCardCVVFull = false
    
    var inputCardNumber: String?
    
    let addCardInteractor = AddCardInteractor()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func setupUnderLinesGrayColor() {
        for line in underLinesArray {
            line.tintColor = PaymentWaysColors.grayColor.value
        }
    }
    
    private func setupUnderLinesBlueColor() {
        for line in underLinesArray {
            line.tintColor = PaymentWaysColors.blueColor.value
        }
    }
    
    private func animationAddCard() {
        
        UIView.animate(withDuration: 2) {
            if let keyboardHeight = self.keyboardHeight {
                
                self.view.addSubview(self.addCardView)
                self.addCardView?.frame.origin.y = self.view.frame.height - keyboardHeight - self.addCardView!.frame.height
                
                self.bgImageTopConstraint.constant = 10 //self.view.frame.height - keyboardHeight - self.addCardView!.frame.height - self.bgImageView.frame.height * 1.5
                self.view.superview?.layoutIfNeeded()
            }
        } completion: { _ in
            self.cardNumberTextField.becomeFirstResponder()
        }
    }
    
    private func animationAddCardConfirm() {
        
        if let cardNumber = inputCardNumber {
            let finalText = addCardInteractor.separated(text: cardNumber)
            let textAttribute = addCardInteractor.createTextAttribute(for: finalText)
            infoTextView.attributedText = textAttribute
        } else {
            infoTextView.text = addCardInteractor.separated(text: "")
        }
        
        

        UIView.animate(withDuration: 2) {
            self.view.addSubview(self.cardConfirmView)
            self.cardConfirmView?.frame.origin.y = self.view.frame.height - self.cardConfirmView!.frame.height
            print(self.cardConfirmView!.frame.height)
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






extension AddCardViewController {


    // MARK: - Add Card Methods
    
    func formated(textField: UITextField, max: Int, pattern: String) -> String {
        
        guard var text = textField.text else { return "" }
        
        switch text.count {
        case max:
            textField.deleteBackward()
            text = textField.text!
        default:
            let formatedCardNumber = textField.text?
                .applyPatternOnNumbers(pattern: pattern, replacmentCharacter: "#")
            textField.text = formatedCardNumber
        }
        
        return textField.tag == 1 ? text : text.applyPatternOnNumbers(pattern: ConstantText.normalNumberFormat.rawValue,
                                          replacmentCharacter: "#")
    }
    
    func checkAllCardFields() {
        
        if isCardNumberFull && isCardDateFull && isCardCVVFull {
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.blueColor.value
            setupUnderLinesBlueColor()
            linkCardButtonOutlet.isEnabled = true
        } else {
            linkCardButtonOutlet.backgroundColor = PaymentWaysColors.grayColor.value
            setupUnderLinesGrayColor()
            linkCardButtonOutlet.isEnabled = false
        }
    }
    
    // MARK: - Add Card Actions
    
    @IBAction func cardNumberTextFieldAction(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }
        
        cardNumber = formated(textField: sender, max: 20, pattern: ConstantText.cardNumber.rawValue)
        
        if count >= 19 {
            cardDateTextField.becomeFirstResponder()
            isCardNumberFull = true
        } else {
            isCardNumberFull = false
        }
        
        if count > 4 {
            cardImageView.image = #imageLiteral(resourceName: "Visa")
        } else {
            cardImageView.image = nil
        }
        
        checkAllCardFields()
    }
    
    @IBAction func cardDateTextFieldAction(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }
        
        cardDate = formated(textField: sender, max: 6, pattern: ConstantText.cardDate.rawValue)
        
        if count >= 5 {
            cardCVVTextField.becomeFirstResponder()
            isCardDateFull = true
        } else {
            isCardDateFull = false
        }
        
        checkAllCardFields()
    }
    
    @IBAction func cardCVVTextFieldAction(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }
        
        cardCVV = formated(textField: sender, max: 4, pattern: ConstantText.cardCVV.rawValue)
        
        if count >= 3 {
            isCardCVVFull = true
        } else {
            isCardCVVFull = false
        }
        
        checkAllCardFields()
        
    }
    
    @IBAction func linkCardButtonAction(_ sender: Any) {
        
        //let passData = ["number" : cardNumber, "expiry_date" : cardDate, "cvc" : cardCVV]
        
        inputCardNumber = cardNumber
        

        UIView.animate(withDuration: 1.5) {

            self.addCardView.frame.origin.y = self.view.frame.height

            self.cardCVVTextField.resignFirstResponder()
            self.cardNumberTextField.resignFirstResponder()
            self.cardDateTextField.resignFirstResponder()

        } completion: { _ in
            
            //let inputCardNumber = "11111111" // cardNumber
//            let passData = CardsUserDefaultsModel(id: 111111, number: "11111111", expiry_date: "11/11", status: "new")
            
           // let id = passData.id
            
            //self.addCardInteractor.getCard(id: id)
                
                //        addCardInteractor.getUserID()
                //        addCardInteractor.postCardData(passData: passData) { dataModel in
                //            if let dataModel = dataModel {
                //              newCardsArray?.append(dataModel)
                //              UserDefaultsManager.shared.newCardsData = newCardsArray
                //            }
                //        }
            //}
            
            self.addCardView.removeFromSuperview()
        }
        
        
        

    }
    
    

   
}


extension AddCardViewController {
    
    
    @IBAction func confirmButtonAction(_ sender: Int) {
      

    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        cardConfirmView.removeFromSuperview()
        
//        UIView.animate(withDuration: 1) {
//
//           // guard let window = self.view.frame.height else { return }
//
//
//
//
//        }
}

}
