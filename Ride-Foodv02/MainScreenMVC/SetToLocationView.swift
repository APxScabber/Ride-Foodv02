//
//  SetToLocationView.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 26.08.2021.
//

import UIKit

protocol SetToLocationDelegate: AnyObject {
    func pressConfirm()
    func zoomAllMarkers()
}

class SetToLocationView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: SetToLocationDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var underLineView: UIView!
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField! { didSet {
        locationTextField.font = UIFont.SFUIDisplayRegular(size: 17.0)
        locationTextField.isUserInteractionEnabled = false
    }}
    @IBOutlet weak var roundedView: RoundedView!
    @IBOutlet weak var confirmButton: UIButton!
    
    

    // MARK: - Actions
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        delegate?.pressConfirm()
    }
}
