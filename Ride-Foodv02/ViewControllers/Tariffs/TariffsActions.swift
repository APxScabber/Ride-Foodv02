//
//  TariffsActions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation
import UIKit

extension TariffsViewController {
    
    //При нажатии на кнопку Заказать такси переходим на главный контроллер
    @IBAction func orderTaxiAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainScreenViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
