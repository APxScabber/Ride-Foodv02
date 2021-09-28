//
//  TariffsCollectionViewCell.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 20.06.2021.
//

import UIKit

class TariffsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellLabel: UILabel! { didSet {
        cellLabel.font = UIFont.SFUIDisplayLight(size: 12.0)
    }}
    @IBOutlet weak var cellImageButton: UIButton!
    
}
