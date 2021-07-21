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
    
    #warning("Убрать из этого контроллера это свойство")
    //let tariffsInteractor = TariffsInteractor()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tariffsInteractor.getUserID()
//        guard let userID = tariffsInteractor.userID else { return }
//
//        tariffsInteractor.loadTariffs(userID: userID) { (dataModel) in
//            guard let tariffsData = dataModel else { return }
//            print("Тариф: \(tariffsData.name)")
//            print("Автомобили: \(tariffsData.cars)")
//            print("Описание: \(tariffsData.description)")
//        }
    
    }
    
    // MARK: - Methods
    
    
    // MARK: - Actions

    @IBAction func tariffsAction(_ sender: Any) {

        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Tariffs", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "Tariffs") //as! TariffsPageViewController
        //vc.navigationTitle = "Тарифы"
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func paymentWaysAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PaymentWays", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PaymentWaysMain") //as! PaymentWaysViewController
        //vc.navigationTitle = "Способы оплаты"
       // navigationController?.pushViewController(vc, animated: true)
        
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
