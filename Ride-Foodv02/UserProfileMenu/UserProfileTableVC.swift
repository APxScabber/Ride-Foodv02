//
//  UserProfileTableVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 22.07.2021.
//

import UIKit

class UserProfileTableVC: UITableViewController {
    
    
//    let footerView = UIView()
    let signOutButton = VBButton(backgroundColor: UIColor.ProfileBackgroundColor, title: Localizable.UserProfile.logOut.localized, cornerRadius: 0, textColor: .red, font: UIFont.SFUIDisplayRegular(size: 15)!, borderWidth: 1, borderColor: UIColor.ProfileButtonBorderColor.cgColor)
    
    let backView = ProfileMenuBackgroundView()
    
    @IBOutlet weak var phoneNumberLabel: UILabel! { didSet {
        phoneNumberLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var MyAddressesLabel: UILabel! { didSet {
        MyAddressesLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
        
    }}
    
    @IBOutlet weak var PaymentHistoryLabel: UILabel! { didSet {
        PaymentHistoryLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var OrdersHistoryLabel: UILabel! { didSet {
        OrdersHistoryLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    @IBOutlet weak var PaymentMethodLabel: UILabel! { didSet {
        PaymentMethodLabel.font = UIFont.SFUIDisplayRegular(size: 15.0)
    }}
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
        configureSignOutButton()
       
        
    }
    
    func configureUI(){
        navigationItem.title = Localizable.UserProfile.profile.localized
        tableView.isScrollEnabled = false
       
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
        
        phoneNumberLabel.text       = Localizable.UserProfile.enterPhoneNumber.localized
        MyAddressesLabel.text       = Localizable.UserProfile.myAddresses.localized
        PaymentHistoryLabel.text    = Localizable.UserProfile.paymentHistory.localized
        OrdersHistoryLabel.text     = Localizable.UserProfile.ordersHistory.localized
        PaymentMethodLabel.text     = Localizable.UserProfile.paymentMethod.localized
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    func configureSignOutButton(){
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }
    
    @objc func signOut(){
        print("did sign out")
    }
  
    
    func configureNavigationItem(){
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
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0  {
            print("Номер телефона")
            }
        if indexPath.section == 0 && indexPath.row == 1  {
            goToStoryboard(name: "Addresses")
            }
        if indexPath.section == 1 && indexPath.row == 0  {
            goToStoryboard(name: "PaymentHistory")
            }
        if indexPath.section == 1 && indexPath.row == 1  {
            print("История заказов")
            }
        if indexPath.section == 1 && indexPath.row == 2  {
            goToStoryboard(name: "PaymentWays")
            }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
