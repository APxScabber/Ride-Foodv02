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
    
    var addressToPass = UserAddressMO()
    var gonnaUpdateAddress = false
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "houseBackgroundImage")
        return imageView
    }()
    
    @IBOutlet weak var MyAddressesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        fetch()
        addNewAddressButton()
        addBackgroundImageView()
        MyAddressesTableView.tableFooterView = UIView()
    }
    
    
    func addBackgroundImageView(){
      
    
        view.addSubview(backgroundImageView)
        MyAddressesTableView.backgroundView = backgroundImageView
       
        
        NSLayoutConstraint.activate([
            backgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 180),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -180)
        ])
    }
    
    
    func fetch(){
        PersistanceManager.shared.fetchAddresses { result in
            switch result{
            case .success(let data):
                print("Successfully fetched")
                self.addresses = data
                print(self.addresses)
                print(self.addresses.isEmpty)
                guard !self.addresses.isEmpty else {
                    DispatchQueue.main.async {
                      
                        let emptyView = AddressesEmptyStateView()
                        emptyView.frame = self.MyAddressesTableView.bounds
                        self.MyAddressesTableView.addSubview(emptyView)
                    }
                    return
                }
                for i in self.MyAddressesTableView.subviews{
                    if i is AddressesEmptyStateView{
                        i.removeFromSuperview()
                    }
                }
                self.MyAddressesTableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddNewAddressVC
        vc.delegate = self
        if addressToPass != nil && gonnaUpdateAddress == true {
            vc.isUPdatingAddress = true
            vc.passedAddress = addressToPass
        }
    }
    
    @objc func addnewAddress(){
        performSegue(withIdentifier: "addNewAddressSegue", sender: self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressToPass = addresses[indexPath.row]
        gonnaUpdateAddress = true
        self.performSegue(withIdentifier: "addNewAddressSegue", sender: self)
        gonnaUpdateAddress = false
    }
    
    
}
extension AddressesVC: AddNewAddressDelegate{
    func didAddNewAddress() {
        print("successfully implimented Protocol")
       fetch()
    }
    
    
}
