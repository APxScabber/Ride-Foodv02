//
//  MainViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 10.06.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataManager.shared.fetchCoreData { result in
            
            switch result {
            case .success(let model):
                let userData = model.first
                    print(userData!.id!)
                    print(userData!.settings!.language!)
            case .failure(let error):
                print(error)
            case .none:
                return
            }
        }
    }
    
    // MARK: - Methods
    
    
    // MARK: - Actions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
