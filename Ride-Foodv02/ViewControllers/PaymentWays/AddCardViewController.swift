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
    
    //Outlets для Add Scores View
//    @IBOutlet weak var addScoresView: UIView!
//    @IBOutlet weak var congratulatioTitleLabel: UILabel!
//    @IBOutlet weak var youHaveLabel: UILabel!
//    @IBOutlet weak var addScoresLabel: UILabel!
//    @IBOutlet weak var addScoresInfoLabel: UILabel!
//    @IBOutlet weak var newOrderButtonOutlet: UIButton!
//    @IBOutlet weak var moreDetailsButtonOutlet: UIButton!
    
    
    
    
    
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
        
        navigationItem.title = titleNavigation
        registerForKeyboardNotification()
        bgImageTopConstraint.constant = view.frame.height / 2
        setupUnderLinesGrayColor()
        addCardInteractor.getUserID()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideTextField.becomeFirstResponder()
        setupAddCardView()
        setupAddCardConfirmView()
        //setupAddScoresView()
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
    
//    private func setupAddScoresView() {
//        addScoresView.frame.size = CGSize(width: view.frame.width, height: 265)
//        addScoresView.frame.origin.y = view.frame.height
//
//        addScoresView.layer.cornerRadius = view.frame.width / 16
//        addScoresView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//
//        addScoresView.layer.shadowColor = UIColor.black.cgColor
//        addScoresView.layer.shadowOpacity = 1
//        addScoresView.layer.shadowOffset = .zero
//        addScoresView.layer.shadowRadius = 10
//
//        congratulatioTitleLabel.text = AddScoresViewText.congratulations.text()
//        youHaveLabel.text = AddScoresViewText.youHave.text()
//        addScoresInfoLabel.text = AddScoresViewText.scoresInfo.text()
//
//        newOrderButtonOutlet.style()
//        newOrderButtonOutlet.backgroundColor = TariffsColors.blueColor.value
//        newOrderButtonOutlet.setTitle(AddScoresViewText.newOrder.text(), for: .normal)
//        moreDetailsButtonOutlet.setTitle(AddScoresViewText.moreDetails.text(), for: .normal)
//
//    }
    
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
                
                self.bgImageTopConstraint.constant = 10
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

            self.bgImageTopConstraint.constant = 80
            self.view.superview?.layoutIfNeeded()
        }
    }
    
//    private func animationAddScores() {
//        
//        //if let cardNumber = inputCardNumber {
//        //    let finalText = addCardInteractor.separated(text: cardNumber)
//        //    let textAttribute = addCardInteractor.createTextAttribute(for: finalText)
//        //    infoTextView.attributedText = textAttribute
//        //} else {
//        //    infoTextView.text = addCardInteractor.separated(text: "")
//       // }
//        UIView.animate(withDuration: 2) {
//            self.view.addSubview(self.addScoresView)
//            self.addScoresView?.frame.origin.y = self.view.frame.height - self.addScoresView!.frame.height
//
//            //self.bgImageTopConstraint.constant = 80
//            self.view.superview?.layoutIfNeeded()
//        }
//    }
    

    
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
        
        
        
        inputCardNumber = cardNumber
        

        UIView.animate(withDuration: 1.5) {

            self.addCardView.frame.origin.y = self.view.frame.height

            self.cardCVVTextField.resignFirstResponder()
            self.cardNumberTextField.resignFirstResponder()
            self.cardDateTextField.resignFirstResponder()

        } completion: { _ in
            
            let passData = ["number" : self.cardNumber, "expiry_date" : self.cardDate, "cvc" : self.cardCVV]
            
            self.addCardInteractor.postCardData(passData: passData) { model in
                self.cardID = model?.id
            }
            
            self.addCardView.removeFromSuperview()
        }
    }
}


extension AddCardViewController {
    
    
    @IBAction func confirmButtonAction(_ sender: Int) {
      
        UIView.animate(withDuration: 1.5) {
            
            self.cardConfirmView.frame.origin.y = self.view.frame.height
            
            if let cardID = self.cardID {
                self.addCardInteractor.approvedCard(with: cardID)
            }
            
        } completion: { _ in
            
            //self.animationAddScores()
            self.navigationController?.popViewController(animated: true)
            self.cardConfirmView.removeFromSuperview()
            
        }
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        cardConfirmView.removeFromSuperview()
}

}

//extension AddCardViewController {
//    
//    @IBAction func newOrderButtonAction(_ sender: Any) {
//    }
//    
//}
