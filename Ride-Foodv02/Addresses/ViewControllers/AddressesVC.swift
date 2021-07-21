//
//  AddressesVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 21.07.2021.
//

import UIKit

class AddressesVC: UIViewController {
    
    var addresses: [UserAddressMO] = []
    
    @IBOutlet weak var MyAddressesBackgroundImageView: UIImageView!
    
    @IBOutlet weak var MyAddressesTableView: UITableView!
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        
    }
    
    
    
    func fetch(){
        PersistanceManager.shared.fetchAddresses { result in
            switch result{
            case .success(let data):
                self.addresses = data
            case .failure(let error):
                print(error)
            }
        }
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
