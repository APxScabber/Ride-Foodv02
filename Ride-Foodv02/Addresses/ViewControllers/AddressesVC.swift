//
//  AddressesVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit

class AddressesVC: UIViewController {
    
    let newAddressButton = VBButton(backgroundColor: UIColor.SkillboxIndigoColor, title: "Добавить адрес", cornerRadius: 15, textColor: .white, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor)
    
    var addresses: [UserAddressMO] = []
    
    @IBOutlet weak var MyAddressesBackgroundImageView: UIImageView!
    
    @IBOutlet weak var MyAddressesTableView: UITableView!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        fetch()
        addNewAddressButton()
        
       
        
    }
    
    
    
    func fetch(){
        PersistanceManager.shared.fetchAddresses { result in
            switch result{
            case .success(let data):
                print("Successfully fetched")
                self.addresses = data
                print(self.addresses)
                print(self.addresses.isEmpty)
                if self.addresses.isEmpty {
                    print("Something is here")
                    DispatchQueue.main.async {
                        let emptyView = AddressesEmptyStateView()
                        emptyView.frame = self.MyAddressesTableView.bounds
                        self.MyAddressesTableView.addSubview(emptyView)
                    }
                
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureNavigationItem(){
        let doneButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .black
        navigationItem.leftBarButtonItem = doneButton
        
    }
    
    func addNewAddressButton(){
        view.addSubview(newAddressButton)
        newAddressButton.addTarget(self, action: #selector(addnewAddress), for: .touchUpInside)
        NSLayoutConstraint.activate([
            newAddressButton.heightAnchor.constraint(equalToConstant: 50),
            newAddressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            newAddressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            newAddressButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    @objc func addnewAddress(){
        print("go to the new screen")
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }

}

extension AddressesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! MyAddressesTableViewCell
        let address = addresses[indexPath.row]
        cell.configureCells(address: address)
        return cell
    }
    
    
}
