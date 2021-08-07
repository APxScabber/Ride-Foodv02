//
//  AddressesVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit

class AddressesVC: UIViewController {
    
    let CoreDataContext = PersistanceManager.shared.context
    
    var showRemoteAddresses: Bool = false
    
    
    let newAddressButton = VBButton(backgroundColor: UIColor.SkillboxIndigoColor, title: "Добавить адрес", cornerRadius: 15, textColor: .white, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor)
    
    var addresses: [UserAddressMO] = []
    var remoteAddresses: [AddressData] = []
    
    var addressToPass = AddressData()
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
        addNewAddressButton()
//        fetch()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.addBackgroundImageView()
        getAddressesFromServer()
        
    }
    
    
    func addBackgroundImageView(){
      
    
        view.addSubview(backgroundImageView)
        self.view.bringSubviewToFront(MyAddressesTableView)
        self.view.bringSubviewToFront(newAddressButton)
//        MyAddressesTableView.backgroundView = backgroundImageView
       
        
        NSLayoutConstraint.activate([
            backgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200),
            backgroundImageView.bottomAnchor.constraint(equalTo: newAddressButton.topAnchor, constant: -150)
        ])
    }
    
    func setEmptyStateView() {
        guard !self.remoteAddresses.isEmpty else {
            DispatchQueue.main.async {
                let emptyView = AddressesEmptyStateView()
                emptyView.frame = self.MyAddressesTableView.bounds
                self.MyAddressesTableView.addSubview(emptyView)
            }
            return
        }
        DispatchQueue.main.async {
            for i in self.MyAddressesTableView.subviews{
                if i is AddressesEmptyStateView{
                    i.removeFromSuperview()
                    
                }
        }
   
        
    }
    }
    
    func getAddressesFromServer(){
        
        remoteAddresses.removeAll()
        AddressesNetworkManager.shared.getTheAddresses { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.failure(let error):
                print("ERROR")
                print(error)
            case .success(let data):
                DispatchQueue.main.async {
                    self.remoteAddresses = data
                    self.setEmptyStateView()
                    self.showRemoteAddresses = true
                    self.MyAddressesTableView.reloadData()
                    self.MyAddressesTableView.tableFooterView = UIView()
                 
                    
                }
              
                
            }
        }
    }
    
  
    
    func fetch(){
        showRemoteAddresses = false
        PersistanceManager.shared.fetchAddresses { result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    print("Successfully fetched")
                    self.addresses = data
                    print(self.addresses)
                    print(self.addresses.isEmpty)
                        self.setEmptyStateView()
                        self.MyAddressesTableView.reloadData()
                        self.MyAddressesTableView.tableFooterView = UIView()
                       
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
        
        return showRemoteAddresses ? remoteAddresses.count : addresses.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! MyAddressesTableViewCell
        if showRemoteAddresses {
            let address = remoteAddresses[indexPath.row]
          
            cell.configureCells(address: address.name ?? "", fullAddress: address.address ?? "")
            return cell
        } else {
            let address = addresses[indexPath.row]
            cell.configureCells(address: address.title ?? "", fullAddress: address.fullAddress ?? "")
            return cell
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        addressToPass = remoteAddresses[indexPath.row]
        gonnaUpdateAddress = true
        self.performSegue(withIdentifier: "addNewAddressSegue", sender: self)
        gonnaUpdateAddress = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}
extension AddressesVC: AddNewAddressDelegate{
    func didAddNewAddress() {
        print("successfully implimented Protocol")
       fetch()
        getAddressesFromServer()
    }
    
    
}
