//
//  ConfirmViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet var codeConfirmTextField: [UITextField]!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    //MARK: - Setup Values
    
    private var timer: Timer?
    
    var phoneNumber = ""
    private var seconds = 30
    
    let loginInteractor = LoginInteractor()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Таймер обратного отсчета, для повторной отправки кода подтверждения
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupInfoTextView), userInfo: nil, repeats: true)
        
        nextButtonOutlet.style()
        setupInfoTextView()
    }
    
    //MARK: - @objc Methods
    
    //Метод формирующий внешний вид TextView с обратеым отсчетом, а также логика повидения при истечкнии времени
    @objc func setupInfoTextView() {
        
        if seconds < 0 {
            seconds = 30
            loginInteractor.reciveConfirmCode(from: phoneNumber)
        }
        
        let licenseText = "На номер \(phoneNumber) отправлено смс с кодом. Повторная отправка через \(seconds) секунд"
        
        let textCount = licenseText.count
        var startColorLocation = textCount - 10
        var colorLenght = 10
        
        if textCount == 85 {
            startColorLocation = textCount - 9
            colorLenght = 9
        }
        
        let attributedString = NSMutableAttributedString(string: licenseText)
       
        infoTextView.textColor = .systemGray
       
        attributedString.addAttributes([ .foregroundColor : UIColor.systemBlue], range: NSRange(location: startColorLocation, length: colorLenght))
        
        infoTextView.attributedText = attributedString
        infoTextView.textAlignment = .center
        
        let padding = infoTextView.textContainer.lineFragmentPadding
        infoTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        seconds -= 1
    }
    
    //MARK: - Actions
    
    //Действие при начале редактирования TextFileds
    @IBAction func startEditCodeTextField(_ sender: UITextField) {
        sender.background = #imageLiteral(resourceName: "confirmNotEmpty")
    }
    
    //Действие во время редактирования TextFileds
    @IBAction func editingCodeTextField(_ sender: UITextField) {
        
        guard let count = sender.text?.count else { return }

        let nextTextField = sender.tag - 1
        
        if count >= 1 {
            let newNumber = sender.text?.removeLast()
            sender.text?.removeAll()
            sender.text = String(newNumber!)
        }
        
        guard nextTextField != 3 else {
            sender.resignFirstResponder()
            return
        }
        
        codeConfirmTextField[nextTextField + 1].becomeFirstResponder()
    }
    
    //Действие при окончание редактирования TextFileds
    @IBAction func endEditCodeTextField(_ sender: UITextField) {
        if sender.text == "" {
            sender.background = #imageLiteral(resourceName: "confirmEmpty")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
