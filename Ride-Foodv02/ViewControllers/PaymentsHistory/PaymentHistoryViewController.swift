//
//  PaymentHistoryViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import UIKit

protocol ReloadDelegate {
    func reloadTableView()
}

class PaymentHistoryViewController: UIViewController, ReloadDelegate {

    
    
    // MARK: - Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var cellHeight: CGFloat = 172
    // MARK: - Properties
    
    let navigationTitle = PaymentHistoryText.navigationTitle.text()
    
    var testArray = [String]()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        testArray = ["One", "Two", "Three", "Four"]
        
        
        navigationItem.title = navigationTitle
        
        checkHistoryEmpty()

        
        


    }
    
    // MARK: - Methods
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    
    private func presentSecondViewController(with data: CellData) {
        let vc = UIStoryboard(name: "PaymentHistory", bundle: nil).instantiateViewController(withIdentifier: "PaymentHistoryBig") as! PaymentHistoryBigViewController

        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .crossDissolve
        vc.data = data
        vc.delegate = self
        present(vc, animated: true)
    }
    
    private func animating(cell: PaymentHistoryTableViewCell, tableView: UITableView) {
        //print(cell.frame.origin.y)
        //print(view.frame.height)
        //let cellPositionY = cell.frame.origin.y
       // let centerPositionY = view.frame.height // 2 - cell.frame.size.height
        
        //cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        //cell.transform = CGAffineTransform(translationX: 0, y: cellPositionY)
        
        let data = CellData(title: cell.testTextLabel.text!)
        
        //print(cell.frame.size.height)
        
        

        
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 0
            self.presentSecondViewController(with: data)
            //self.tableView.beginUpdates()
            //cell.frame.size.height = 410
            //self.cellHeight = 410
            //self.tableView.endUpdates()
            //cell.transform = CGAffineTransform(scaleX: 1, y: 2)
            //cell.transform = CGAffineTransform(translationX: 0, y: centerPositionY)
            //cell.frame.origin.y = self.view.frame.height
        } completion: { _ in
            print(cell.frame.origin.y)
            //print(cell.frame.origin)
            //print(cell.frame.size.height)
            cell.tag = 0
            
            
        }
        
//        UIView.animate(withDuration: 3) {
//            cell.transform = CGAffineTransform(scaleX: 1, y: 2.38)
//        }

        
        

        
//        UIView.animate(withDuration: 2) {
//            cell.transform = CGAffineTransform(translationX: 0, y: centerPositionY)
//        }
        
    
    }
    
    private func checkHistoryEmpty() {

        if testArray.isEmpty {
            
            tableView.alpha = 0
            searchBar.alpha = 0
            bgImage.alpha = 1
            infoLabel.alpha = 1
        } else {
            
            tableView.alpha = 1
            searchBar.alpha = 1
            bgImage.alpha = 0
            infoLabel.alpha = 0
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

// MARK: - Extensions TableView Data Source

extension PaymentHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.tag == 1 {
            cellHeight = 410
        } else {
            cellHeight = 172
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentHistoryTableViewCell
        cell.alpha = 1
        cell.testTextLabel.text = testArray[indexPath.row]
        
        return cell
    }
    
    
}

// MARK: - Extensions TableView Delegate

extension PaymentHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let data = CellData(title: testArray[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) as! PaymentHistoryTableViewCell
        
        //print(cell.frame.origin.y)
        tableView.beginUpdates()
        cell.tag = 1
        tableView.endUpdates()
        
        //print(cell.frame.origin.y)
        
        animating(cell: cell, tableView: tableView)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


