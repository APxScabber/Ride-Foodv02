//
//  AddNewAddressVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.07.2021.
//

import UIKit

class AddNewAddressVC: UIViewController {
    
    let CoreDataContext = PersistanceManager.shared.context
    
    @IBOutlet weak var newAddressScrollView: UIScrollView!
    
    @IBOutlet weak var newAddressParentView: UIView!
    
//    Save Button
    
    let SaveButton = VBButton(backgroundColor: UIColor.SkillboxIndigoColor, title: "Сохранить", cornerRadius: 15, textColor: .white, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor)
    
//    Stack views
    var generalAddressStackView = UIStackView()
    var locationStackView = UIStackView()
    var deliveryInformationStackView = UIStackView()
    var officeAndIntercomStackView = UIStackView()
    var EntranceAndFloorStackView = UIStackView()
    
//    sources for locationStackView
   
    var locationMarkImageView = UIImageView()
    
//    Custom views w/ textviews
    var addressTitleView = VBTextView()
    var addressDescriptionView = VBTextView()
    var mapButton = VBMapButton()
    var driverCommentaryView = VBTextView()
    
//    Separator between stack views
    var separatorView = UIView()
    var separatorLabel = UILabel()

    var officeNumberView = VBTextView()
    var intercomNumberView = VBTextView()
    var entranceNumberView = VBTextView()
    var floorNumber = VBTextView()
    var deliveryCommentaryView = VBTextView()
    
    var keyboardIsExtended: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextViewDelegates()
        placeSaveButton()
        setInitialTextViewTexts()
        configureAddressStackView()
        configureSeparatorView()
        configureDeliveryStackView()
        moveViewIfKeyboardShowsUp()
        createDismisskeyboardTapGesture()
        configureNavigationItem()
      //  newAddressParentView.backgroundColor = .gray
        
       // generalStackView.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    func setTextViewDelegates(){
        let views = [addressTitleView, addressDescriptionView, driverCommentaryView, officeNumberView, intercomNumberView, entranceNumberView, floorNumber, deliveryCommentaryView]
        views.forEach { element in
            element.textView.delegate = self
            if !element.textView.text.isEmpty{
                element.placeholderLabel.isHidden = true
            }
        }
    }
    
    func configureNavigationItem(){
        let doneButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .black
        navigationItem.leftBarButtonItem = doneButton
        
    }
    
    @objc func dismissVC(){
        navigationController?.popViewController(animated: true)
    }
    
    func createDismisskeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func moveViewIfKeyboardShowsUp(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardAppear(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
         else {
           // if keyboard size is not available for some reason, dont do anything
           return
         }

         let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
         newAddressScrollView.contentInset = contentInsets
        newAddressScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardDisappear(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            
        // reset back the content inset to zero after keyboard is gone
        newAddressScrollView.contentInset = contentInsets
        newAddressScrollView.scrollIndicatorInsets = contentInsets
    }
    
    func setInitialTextViewTexts(){
        addressTitleView.textView.text = "Название адреса"
        addressDescriptionView.textView.text = "Адрес"
        driverCommentaryView.textView.text = "Комментарий для водителя"
        separatorLabel.text = "Для доставки"
        officeNumberView.textView.text = "Кв./офис"
        intercomNumberView.textView.text = "Домофон"
        entranceNumberView.textView.text = "Подъезд"
        floorNumber.textView.text = "Этаж"
        deliveryCommentaryView.textView.text = "Комментарий для курьера"
        
    }
    func setPlaceHolderTexts(textView: UITextView) -> String{
        if textView.text.isEmpty {
            textView.textColor = UIColor.DarkGrayTextColor
        }
        var textToReturn = String()
        switch textView {
        case addressTitleView.textView:
           textToReturn = textView.text.isEmpty ? "Название адреса" : textView.text
        case addressDescriptionView.textView:
            textToReturn = textView.text.isEmpty ? "Адрес" : textView.text
        case driverCommentaryView.textView:
            textToReturn = textView.text.isEmpty ? "Комментарий для водителя" : textView.text
        case officeNumberView.textView:
            textToReturn = textView.text.isEmpty ? "Кв./офис" : textView.text
        case intercomNumberView.textView:
            textToReturn = textView.text.isEmpty ? "Домофон" : textView.text
        case entranceNumberView.textView:
            textToReturn = textView.text.isEmpty ? "Подъезд" : textView.text
        case floorNumber.textView:
            textToReturn = textView.text.isEmpty ? "Этаж" : textView.text
        case deliveryCommentaryView.textView:
            textToReturn = textView.text.isEmpty ? "Комментарий для курьера" : textView.text
        default:
             break
        }
        return textToReturn
    }
    
    func configureAddressStackView(){
        newAddressParentView.addSubview(generalAddressStackView)
        generalAddressStackView.axis           = .vertical
        generalAddressStackView.distribution   = .fillEqually
        generalAddressStackView.spacing        = 20
        addViewsToStackView()
        
        let padding: CGFloat = 25
        generalAddressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            generalAddressStackView.topAnchor.constraint(equalTo: newAddressParentView.topAnchor, constant: 7),
            generalAddressStackView.leadingAnchor.constraint(equalTo: newAddressParentView.leadingAnchor, constant: padding),
            generalAddressStackView.trailingAnchor.constraint(equalTo: newAddressParentView.trailingAnchor, constant: -padding),
            generalAddressStackView.bottomAnchor.constraint(equalTo: newAddressParentView.bottomAnchor, constant: -550)
        ])
    }
    
    func addViewsToStackView(){
        configurelocationStackView()
        generalAddressStackView.addArrangedSubview(addressTitleView)
        generalAddressStackView.addArrangedSubview(locationStackView)
        generalAddressStackView.addArrangedSubview(driverCommentaryView)
    }
    
    func configurelocationStackView(){
        locationStackView.axis           = .horizontal
        locationStackView.distribution   = .fill
        locationStackView.spacing        = 0
       
        locationMarkImageView.contentMode = .scaleAspectFit
        locationMarkImageView.clipsToBounds = true
        
        locationMarkImageView.image = UIImage(named: "Annotation")
        
        locationStackView.addArrangedSubview(locationMarkImageView)
        locationStackView.addArrangedSubview(addressDescriptionView)
        locationStackView.addArrangedSubview(mapButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: locationMarkImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 14),
            NSLayoutConstraint(item: locationMarkImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 21),
            NSLayoutConstraint(item: mapButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75)
     
        ])
        
    }
    
    func configureSeparatorView(){
        newAddressParentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.SeparatorColor
        separatorView.addSubview(separatorLabel)
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.font = UIFont.SFUIDisplaySemibold(size: 18)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: newAddressParentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: newAddressParentView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: generalAddressStackView.bottomAnchor, constant: 15),
            separatorView.heightAnchor.constraint(equalToConstant: 45),
            
            
            separatorLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 25),
            separatorLabel.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 248),
            separatorLabel.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -13),
            separatorLabel.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor)
        ])
        
    }
//    Here we configure delivery information stackview
    func configureOfficeStackView(){
        officeAndIntercomStackView.axis           = .horizontal
        officeAndIntercomStackView.distribution   = .fillEqually
        officeAndIntercomStackView.spacing        = 20
        
        officeAndIntercomStackView.addArrangedSubview(officeNumberView)
        officeAndIntercomStackView.addArrangedSubview(intercomNumberView)
    }
    
    func configureEntranceStackView(){
        EntranceAndFloorStackView.axis           = .horizontal
        EntranceAndFloorStackView.distribution   = .fillEqually
        EntranceAndFloorStackView.spacing        = 20
        
        EntranceAndFloorStackView.addArrangedSubview(entranceNumberView)
        EntranceAndFloorStackView.addArrangedSubview(floorNumber)
    }
    
    func configureDeliveryStackView(){
        
        newAddressParentView.addSubview(deliveryInformationStackView)
        deliveryInformationStackView.axis           = .vertical
        deliveryInformationStackView.distribution   = .fillEqually
        deliveryInformationStackView.spacing        = 20
        deliveryInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        configureOfficeStackView()
        configureEntranceStackView()
    
        deliveryInformationStackView.addArrangedSubview(officeAndIntercomStackView)
        deliveryInformationStackView.addArrangedSubview(EntranceAndFloorStackView)
        deliveryInformationStackView.addArrangedSubview(deliveryCommentaryView)
        
        NSLayoutConstraint.activate([
            deliveryInformationStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            deliveryInformationStackView.leadingAnchor.constraint(equalTo: newAddressParentView.leadingAnchor, constant: 25),
            deliveryInformationStackView.trailingAnchor.constraint(equalTo: newAddressParentView.trailingAnchor, constant: -25),
            deliveryInformationStackView.bottomAnchor.constraint(equalTo: SaveButton.topAnchor, constant: -220)
            
        ])
    }
    
    func placeSaveButton(){
        SaveButton.translatesAutoresizingMaskIntoConstraints = false
        newAddressParentView.addSubview(SaveButton)
        SaveButton.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        NSLayoutConstraint.activate([
            SaveButton.heightAnchor.constraint(equalToConstant: 50),
            SaveButton.leadingAnchor.constraint(equalTo: newAddressParentView.leadingAnchor, constant: 25),
            SaveButton.trailingAnchor.constraint(equalTo: newAddressParentView.trailingAnchor, constant: -25),
            SaveButton.bottomAnchor.constraint(equalTo: newAddressParentView.bottomAnchor, constant: -30)
        ])
    }
    
    @objc func addAddress(){
        let newAddress = UserAddressMO(context: CoreDataManager.shared.persistentContainer.viewContext)
        newAddress.title = addressTitleView.textView.text
        newAddress.fullAddress = addressTitleView.textView.text
        newAddress.driverCommentary = driverCommentaryView.textView.text ?? ""
        newAddress.delivApartNumber = officeNumberView.textView.text ?? ""
        newAddress.delivIntercomNumber = intercomNumberView.textView.text ?? ""
        newAddress.delivEntranceNumber = entranceNumberView.textView.text ?? ""
        newAddress.delivFloorNumber = floorNumber.textView.text ?? ""
        newAddress.deliveryCommentary = deliveryCommentaryView.textView.text ?? ""
        
        PersistanceManager.shared.addNewAddress(address: newAddress)
        navigationController?.popViewController(animated: true)
        
    }
    


}
extension AddNewAddressVC: UITextViewDelegate{
     func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.DarkGrayTextColor {
              textView.text = nil
              textView.textColor = UIColor.black
          }
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
            textView.text = setPlaceHolderTexts(textView: textView)
     
    }
    
}
