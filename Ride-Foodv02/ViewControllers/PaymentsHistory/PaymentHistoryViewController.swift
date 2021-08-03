//
//  PaymentHistoryViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import UIKit

class PaymentHistoryViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - Properties
    
    let navigationTitle = PaymentHistoryText.navigationTitle.text()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navigationTitle
        
        //tableView.delegate = self
        //tableView.dataSource = self

    }
    
    // MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

// MARK: - Extensions TableView Data Source
/*
extension PaymentHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

// MARK: - Extensions TableView Delegate

extension PaymentHistoryViewController: UITableViewDelegate {
    
}
*/

