//
//  AddNewAddressVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.07.2021.
//

import UIKit

protocol AddNewAddressDelegate: AnyObject{
    func didAddNewAddress()
}

class AddNewAddressVC: UIViewController{
    
//    case of updating the address
    
    var isUPdatingAddress: Bool = false
    var wantToUpdateAddress: Bool = false
    var passedAddress: UserAddressMO?
    
   weak var delegate: AddNewAddressDelegate?
    
    let CoreDataContext = PersistanceManager.shared.context
    
    @IBOutlet weak var newAddressScrollView: UIScrollView!
    
    @IBOutlet weak var newAddressParentView: UIView!
    
//    Save Button
    
    
    
    let SaveButton = VBButton(backgroundColor: UIColor.SkillboxIndigoColor, title: "Сохранить", cornerRadius: 15, textColor: .white, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor)
    let DeleteButton = VBButton(backgroundColor: .clear, title: "Удалить", cornerRadius: 15, textColor: .black, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor )
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
     //   setTextViewDelegates()
        if let currentAddress = passedAddress{
            setUIIfUpdatingAddress(address: currentAddress)
        }
        setTextfieldDelegates()
        setSaveButtonBehavior()
        configureMapButton()
        placeSaveAndDeleteButton()
        setInitialTextViewTexts()
        configureAddressStackView()
        configureSeparatorView()
        configureDeliveryStackView()
        moveViewIfKeyboardShowsUp()
        createDismisskeyboardTapGesture()
        configureNavigationItem()
  
    }
    
    
    func setUIIfUpdatingAddress(address: UserAddressMO){
        if isUPdatingAddress{
            addressTitleView.textView.text = address.title
            addressDescriptionView.textView.text = address.fullAddress
            driverCommentaryView.textView.text = address.driverCommentary
            separatorLabel.text = "Для доставки"
            officeNumberView.textView.text = address.delivApartNumber
            intercomNumberView.textView.text = address.delivIntercomNumber
            entranceNumberView.textView.text = address.delivEntranceNumber
            floorNumber.textView.text = address.delivFloorNumber
            deliveryCommentaryView.textView.text = address.deliveryCommentary
        }
    }
    
    func setTextfieldDelegates(){
        self.addressTitleView.textView.delegate = self
        self.addressDescriptionView.textView.delegate = self
        self.driverCommentaryView.textView.delegate = self
        self.officeNumberView.textView.delegate = self
        self.intercomNumberView.textView.delegate = self
        self.entranceNumberView.textView.delegate = self
        self.floorNumber.textView.delegate = self
        self.deliveryCommentaryView.textView.delegate = self
        
    }
    
    func configureMapButton(){
        mapButton.addTarget(self, action: #selector(openTheMap), for: .touchUpInside)
    }
    @objc func openTheMap(){
        self.performSegue(withIdentifier: "selectLocationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SelectLocationVC
        vc.delegate = self
    }
    

    
    func configureNavigationItem(){
        if isUPdatingAddress{
            navigationItem.title = passedAddress?.title
        }
        
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
        addressTitleView.textView.placeholder = "Название адреса"
        addressDescriptionView.textView.placeholder = "Адрес"
        driverCommentaryView.textView.placeholder = "Комментарий для водителя"
        separatorLabel.text = "Для доставки"
        officeNumberView.textView.placeholder = "Кв./офис"
        intercomNumberView.textView.placeholder = "Домофон"
        entranceNumberView.textView.placeholder = "Подъезд"
        floorNumber.textView.placeholder = "Этаж"
        deliveryCommentaryView.textView.placeholder = "Комментарий для курьера"
        
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
        if !isUPdatingAddress{
        generalAddressStackView.addArrangedSubview(addressTitleView)
        }
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
            NSLayoutConstraint(item: locationMarkImageView, attribute: .trailing, relatedBy: .equal, toItem: addressDescriptionView, attribute: .leading, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: locationMarkImageView, attribute: .centerY, relatedBy: .equal, toItem: addressDescriptionView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mapButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 75),
            NSLayoutConstraint(item: mapButton, attribute: .centerY, relatedBy: .equal, toItem: addressDescriptionView, attribute: .centerY, multiplier: 1, constant: 0),
     
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
    
    func setSaveButtonBehavior(){
        
       
        if wantToUpdateAddress{
            SaveButton.setTitle("Обновить" , for: .normal)
        } else {
            SaveButton.setTitle(!isUPdatingAddress ? "Сохранить" : "Выбрать местом назначения", for: .normal)
        }
        
        SaveButton.isEnabled = !addressTitleView.textView.text!.isEmpty && !addressDescriptionView.textView.text!.isEmpty
        SaveButton.backgroundColor = SaveButton.isEnabled ? UIColor.SkillboxIndigoColor : UIColor.DisabledButtonBackgroundView
        switch SaveButton.title(for: .normal) {
        case "Сохранить":
            SaveButton.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        case "Выбрать местом назначения":
            SaveButton.addTarget(self, action: #selector(setAsMainAddress), for: .touchUpInside)
        case "Обновить":
            SaveButton.addTarget(self, action: #selector(updateAddress), for: .touchUpInside)
        default:
            return
        }
        
      
    }
    
    func placeSaveAndDeleteButton(){
      
        SaveButton.translatesAutoresizingMaskIntoConstraints = false
        newAddressParentView.addSubview(SaveButton)
       
        
        if isUPdatingAddress{
            newAddressParentView.addSubview(DeleteButton)
            
            DeleteButton.translatesAutoresizingMaskIntoConstraints = false
            DeleteButton.addTarget(self, action: #selector(callConfirmActionAndDelete), for: .touchUpInside)
        }
        
        
        NSLayoutConstraint.activate([
            SaveButton.heightAnchor.constraint(equalToConstant: 50),
            SaveButton.leadingAnchor.constraint(equalTo: newAddressParentView.leadingAnchor, constant: 25),
            SaveButton.trailingAnchor.constraint(equalTo: newAddressParentView.trailingAnchor, constant: -25),
            SaveButton.bottomAnchor.constraint(equalTo: newAddressParentView.bottomAnchor, constant: isUPdatingAddress ? -90 : -30)
        
        ])
        
        if isUPdatingAddress{
            NSLayoutConstraint.activate([
                DeleteButton.heightAnchor.constraint(equalToConstant: 50),
                DeleteButton.leadingAnchor.constraint(equalTo: newAddressParentView.leadingAnchor, constant: 25),
                DeleteButton.trailingAnchor.constraint(equalTo: newAddressParentView.trailingAnchor, constant: -25),
                DeleteButton.bottomAnchor.constraint(equalTo: newAddressParentView.bottomAnchor, constant: -30)
            ])
        }
    }
    
    
    
    
    
    @objc func callConfirmActionAndDelete(){
        self.presentConfirmWindow(title: "Удалить адрес?", titleColor: .red, confirmTitle: "Удалить", cancelTitle: "Отмена")
    }
    
    @objc func updateAddress(){
        if isUPdatingAddress && wantToUpdateAddress {
            if let addressToUpdate = passedAddress{
                addressToUpdate.title = addressTitleView.textView.text
                addressToUpdate.fullAddress = addressDescriptionView.textView.text
                addressToUpdate.driverCommentary = driverCommentaryView.textView.text ?? ""
                addressToUpdate.delivApartNumber = officeNumberView.textView.text ?? ""
                addressToUpdate.delivIntercomNumber = intercomNumberView.textView.text ?? ""
                addressToUpdate.delivEntranceNumber = entranceNumberView.textView.text ?? ""
                addressToUpdate.delivFloorNumber = floorNumber.textView.text ?? ""
                addressToUpdate.deliveryCommentary = deliveryCommentaryView.textView.text ?? ""
                
                PersistanceManager.shared.addNewAddress(address: addressToUpdate)
                
                setUIIfUpdatingAddress(address: addressToUpdate)
                wantToUpdateAddress = false
                setSaveButtonBehavior()
            }
         
        }
        
    }
    
    @objc func setAsMainAddress(){
        print("Set as main address")
    }
    
    @objc func addAddress(){
        let newAddress = UserAddressMO(context: CoreDataManager.shared.persistentContainer.viewContext)
        newAddress.title = addressTitleView.textView.text
        newAddress.fullAddress = addressDescriptionView.textView.text
        newAddress.driverCommentary = driverCommentaryView.textView.text ?? ""
        newAddress.delivApartNumber = officeNumberView.textView.text ?? ""
        newAddress.delivIntercomNumber = intercomNumberView.textView.text ?? ""
        newAddress.delivEntranceNumber = entranceNumberView.textView.text ?? ""
        newAddress.delivFloorNumber = floorNumber.textView.text ?? ""
        newAddress.deliveryCommentary = deliveryCommentaryView.textView.text ?? ""
        
        PersistanceManager.shared.addNewAddress(address: newAddress)
        navigationController?.popViewController(animated: true)
        delegate?.didAddNewAddress()
        
    }
    


}

extension AddNewAddressVC: SetLocationDelegate{
    func locationIsSet(location: String) {
        print("delegate successfully implemented")
        self.addressDescriptionView.textView.text = location
        setSaveButtonBehavior()
       
    }
    
    
}

extension AddNewAddressVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isUPdatingAddress{
         wantToUpdateAddress = true
        }
        setSaveButtonBehavior()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isUPdatingAddress{
         wantToUpdateAddress = true
        }
        setSaveButtonBehavior()
        
    }
}

extension AddNewAddressVC: DeleteAddressProtocol{
    func deleteAddress() {
        print("here gonna delete address")
        if let addressToDelete = passedAddress{
        self.CoreDataContext.delete(addressToDelete)
            do{
                try self.CoreDataContext.save()
            } catch{
                print(error.localizedDescription)
            }
            navigationController?.popViewController(animated: true)
            delegate?.didAddNewAddress()
            
        }
        
    }
    
  
    
    
}

extension AddNewAddressVC{
    
    func presentConfirmWindow(title: String, titleColor: UIColor, confirmTitle: String, cancelTitle: String){
        let confirmAlert = VBConfirmAlertVC(alertTitle: title, alertColor: titleColor, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
        confirmAlert.delegate = self
        if #available(iOS 13.0, *) {
            confirmAlert.modalPresentationStyle = .popover
        } else {
            // Fallback on earlier versions
        }
        confirmAlert.modalTransitionStyle = .coverVertical
        self.present(confirmAlert, animated: true)
    }
}
