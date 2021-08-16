//
//  UserProfileTableVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 22.07.2021.
//

import UIKit

class UserProfileTableVC: UITableViewController {
    
    var numbers: [String] = [
        "+13456350493",
        "+15439596832",
        "+17530593284",
        "+14929403929",
      
    ]
    
    
    var enterMobilePhooneNumber = Localizable.UserProfile.enterPhoneNumber.localized
    var myAddressesMenuItem     = Localizable.UserProfile.myAddresses.localized
    var paymentHistoryMenuItem  = Localizable.UserProfile.paymentHistory.localized
    var ordersHistoryMenuItem   = Localizable.UserProfile.ordersHistory.localized
    var paymentMethodMenuItem   = Localizable.UserProfile.paymentMethod.localized
    
    var sectionTwoMenuItems: [String] = []
//    let footerView = UIView()
    let signOutButton = VBButton(backgroundColor: UIColor.ProfileBackgroundColor, title: Localizable.UserProfile.logOut.localized, cornerRadius: 0, textColor: .red, font: UIFont.SFUIDisplayRegular(size: 15)!, borderWidth: 1, borderColor: UIColor.ProfileButtonBorderColor.cgColor)
    
    let backView = ProfileMenuBackgroundView()
 
    
    @IBOutlet weak var PaymentMethodLabel: UILabel! 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        configureSignOutButton()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationItem()
    }
    
    func configureUI(){
        
        
       
        extendedLayoutIncludesOpaqueBars = true
        tableView.isScrollEnabled = true
       
        tableView.addSubview(backView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false
       
        backView.addSubview(signOutButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backView.trailingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.trailingAnchor),
            backView.leadingAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leadingAnchor),
            backView.topAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.topAnchor),
            backView.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor),
            
            signOutButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -35),
            signOutButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    
        tableView.backgroundView = backView
        
        sectionTwoMenuItems = [
            paymentHistoryMenuItem,
            ordersHistoryMenuItem,
            paymentMethodMenuItem
        ]
        tableView.reloadData()
     
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    func configureSignOutButton(){
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }
    
    @objc func signOut(){
        self.presentConfirmWindow(title: Localizable.UserProfile.logoutQuestion.localized, titleColor: .red, confirmTitle: Localizable.UserProfile.logOut.localized, cancelTitle: Localizable.Addresses.cancel.localized)
    }
  
    
    func configureNavigationItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Localizable.UserProfile.profile.localized
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .black
        navigationItem.leftBarButtonItem = doneButton
        
        

        
    }
    
    
    
    func goToStoryboard(name:String) {
        let storyboard = UIStoryboard(name: name, bundle: .main)
        if let supportVC = storyboard.instantiateInitialViewController() as? UINavigationController {
            supportVC.modalPresentationStyle = .fullScreen
            supportVC.modalTransitionStyle = .coverVertical
            
            
            
            present(supportVC, animated: true)
        } else {
            if let supportVC = storyboard.instantiateInitialViewController() {
                supportVC.modalPresentationStyle = .fullScreen
                supportVC.modalTransitionStyle = .crossDissolve
                
                
                
                present(supportVC, animated: true)
        }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        15
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        30
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberToReturn = 0
        
        if section == 0 && numbers.count != 0 {
            numberToReturn = numbers.count + 1
        }
        if section == 0 && numbers.count == 0{
            numberToReturn = 2
        }
        if section == 1 {
            numberToReturn = sectionTwoMenuItems.count
        }
        return numberToReturn
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && numbers.count == 0 && indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
            cell.phoneNumberLabel.text = enterMobilePhooneNumber
            cell.isMainLabel.isHidden = true
            return cell
        }
        if indexPath.section == 0 && indexPath.row != (numbers.count + 1) - 1 && numbers.count != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PhoneNumberTableViewCell.identifier, for: indexPath) as! PhoneNumberTableViewCell
            let number = numbers[indexPath.row]
            cell.phoneNumberLabel.text = number
            cell.isMainLabel.isHidden = true
            return cell
        }
        if indexPath.section == 0 && indexPath.row == 1 && numbers.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemsTableViewCell.identifier, for: indexPath) as! MenuItemsTableViewCell
            cell.menuItemLabel.text = myAddressesMenuItem
            return cell
        }
        if indexPath.section == 0 && indexPath.row == (numbers.count + 1) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemsTableViewCell.identifier, for: indexPath) as! MenuItemsTableViewCell
            cell.menuItemLabel.text = myAddressesMenuItem
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemsTableViewCell.identifier, for: indexPath) as! MenuItemsTableViewCell
            let menuItem = sectionTwoMenuItems[indexPath.row]
            cell.menuItemLabel.text = menuItem
            return cell
        }
     return UITableViewCell()
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row != (numbers.count + 1) - 1 && numbers.count != 0 {
            print("Номер телефона")
        }
        
        
        if indexPath.section == 0 && indexPath.row == 0 && numbers.count == 0{
            print("Номер телефона")
            }
        if indexPath.section == 0 && indexPath.row == 1 && numbers.count == 0{
            goToStoryboard(name: "Addresses")
        }
        
        if indexPath.section == 0 && indexPath.row == (numbers.count + 1) - 1 && numbers.count != 0 {
            goToStoryboard(name: "Addresses")
            }
        if indexPath.section == 1 && indexPath.row == 0  {
            goToStoryboard(name: "PaymentHistory")
            }
        if indexPath.section == 1 && indexPath.row == 1  {
            goToStoryboard(name: "OrderHistory")
            }
        if indexPath.section == 1 && indexPath.row == 2  {
            goToStoryboard(name: "PaymentWays")
            }
    }
 

}

extension UserProfileTableVC{
    func presentConfirmWindow(title: String, titleColor: UIColor, confirmTitle: String, cancelTitle: String){
        let confirmAlert = VBConfirmAlertVC(alertTitle: title, alertColor: titleColor, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
        confirmAlert.resetDelegate = self
        if #available(iOS 13.0, *) {
            confirmAlert.modalPresentationStyle = .popover
        } else {
            // Fallback on earlier versions
        }
        confirmAlert.modalTransitionStyle = .coverVertical
        self.present(confirmAlert, animated: true)
    }
}

extension UserProfileTableVC: ResetEverythingProtocol{
    func deleteEverything() {
        SignOutHelper.shared.resetEverything()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.goToStoryboard(name: "Login")
            print("did sign out")
        }
    }
    
    
}


