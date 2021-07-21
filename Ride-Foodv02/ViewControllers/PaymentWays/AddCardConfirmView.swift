//
//  AddCardConfirmView.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.07.2021.
//

import UIKit

class AddCardConfirmView: UIView {
    

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    let addCardInteractor = AddCardInteractor()

    // MARK: - Methods



    @IBAction func confirmButtonAction(_ sender: Int) {
      

    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        UIView.animate(withDuration: 1) {
            
            guard let window = self.window?.frame.height else { return }
            
            self.frame.origin.y = window
            
            
            
        }
    }
}


