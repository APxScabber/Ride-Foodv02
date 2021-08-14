//
//  AddressesVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit

class AddressesVC: UIViewController {
    
    let CoreDataContext = PersistanceManager.shared.context
    
    var showRemoteAddresses: Bool = true
    
    
    let newAddressButton = VBButton(backgroundColor: UIColor.SkillboxIndigoColor, title: Localizable.Addresses.addAddress.localized, cornerRadius: 15, textColor: .white, font: UIFont.SFUIDisplayRegular(size: 17)!, borderWidth: 0, borderColor: UIColor.white.cgColor)
    
    var Localaddresses: [UserAddressMO] = []
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
        navigationItem.title = Localizable.Addresses.myAddresses.localized
        addNewAddressButton()
        self.addBackgroundImageView()
        configureNavigationItem()
        fetch()
      
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        getAddressesFromServer()
        
        
    }
    
    
    func addBackgroundImageView(){
      
    
        view.addSubview(backgroundImageView)
        self.view.bringSubviewToFront(MyAddressesTableView)
        self.view.bringSubviewToFront(newAddressButton)
//        MyAddressesTableView.backgroundView = backgroundImageView
        self.MyAddressesTableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            backgroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200),
            backgroundImageView.bottomAnchor.constraint(equalTo: newAddressButton.topAnchor, constant: -150)
        ])
    }
    
    func setEmptyStateView(addresses: [Any]) {
        guard !addresses.isEmpty else {
            DispatchQueue.main.async {
                let emptyView = AddressesEmptyStateView()
                emptyView.frame = self.view.bounds
                self.view.addSubview(emptyView)
                self.view.bringSubviewToFront(self.newAddressButton)
            }
            return
        }
        DispatchQueue.main.async {
            for i in self.view.subviews{
                if i is AddressesEmptyStateView{
                    i.removeFromSuperview()
                    
                }
        }
   
        
    }
    }
    
    func createCoreDataInstance(addressesToCopy: [AddressData]?){
        SignOutHelper.shared.resetCoreDataEntity(with: "UserAddressMO")
        Localaddresses.removeAll()
        
        
        
        guard let data = addressesToCopy else {
            return
        }
        for i in data{
            let localAddress = UserAddressMO(context: PersistanceManager.shared.context)
           
            localAddress.id = placeIntIntoString(int: i.id ?? 0)
            localAddress.title = i.name
            localAddress.fullAddress = i.address
            localAddress.driverCommentary = i.commentDriver
            localAddress.delivApartNumber = placeIntIntoString(int: i.flat ?? 0)
            localAddress.delivIntercomNumber = placeIntIntoString(int: i.intercom ?? 0)
            localAddress.delivEntranceNumber = placeIntIntoString(int: i.entrance ?? 0)
            localAddress.delivFloorNumber = placeIntIntoString(int: i.floor ?? 0)
            localAddress.deliveryCommentary = i.commentCourier
            localAddress.isDestination = i.destination ?? false
            
            PersistanceManager.shared.addNewAddress(address: localAddress)
            
        }
   
    }
    
    func getAddressesFromServer(){
        
    
        print("There are \(remoteAddresses.count) remote addresses")
        AddressesNetworkManager.shared.getTheAddresses { [weak self] result in
            guard let self = self else { return }
            switch result{
            case.failure(let error):
                print("ERROR")
                print(error)
            case .success(let data):
                DispatchQueue.main.async {
                    
                    self.showRemoteAddresses = true
                    self.remoteAddresses = data
                    self.createCoreDataInstance(addressesToCopy: self.remoteAddresses)
                    if self.remoteAddresses.isEmpty {
                        self.fetch()
                    }
                    print(self.remoteAddresses)
                    self.setEmptyStateView(addresses: self.remoteAddresses)
                    self.MyAddressesTableView.reloadData()
                   
                 
                    
                }
              
                
            }
        }
    }
    
  
    
    func fetch(){
        self.Localaddresses.removeAll()
        
        guard Localaddresses.isEmpty else {
            return
        }
        PersistanceManager.shared.fetchAddresses { result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async {
                    self.showRemoteAddresses = false
                    self.Localaddresses = data
                    self.setEmptyStateView(addresses: self.Localaddresses)
                        self.MyAddressesTableView.reloadData()
                  
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
        if gonnaUpdateAddress {
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
        
        return showRemoteAddresses ? remoteAddresses.count : Localaddresses.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! MyAddressesTableViewCell
        if showRemoteAddresses{
            let address = remoteAddresses[indexPath.row]
          
            cell.configureCells(address: address.name ?? "", fullAddress: address.address ?? "")
        } else {
            let address = Localaddresses[indexPath.row]
          
            cell.configureCells(address: address.title ?? "", fullAddress: address.fullAddress ?? "")
        }
            return cell
       
        
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard showRemoteAddresses else {
            print("Cannot update address using local address")
            return
        }
        addressToPass = remoteAddresses[indexPath.row]
        gonnaUpdateAddress = true
        self.performSegue(withIdentifier: "addNewAddressSegue", sender: self)
        gonnaUpdateAddress = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}
extension AddressesVC: AddNewAddressDelegate{
    func didAddNewAddress(address: [AddressData]) {
        DispatchQueue.main.async {
            self.createCoreDataInstance(addressesToCopy: address)
      
            self.showRemoteAddresses = true
            self.remoteAddresses.removeAll()
            self.remoteAddresses = address
            print(address.isEmpty)
            self.setEmptyStateView(addresses: address)
            self.MyAddressesTableView.reloadData()
        }
    }
   
    
    
}
