//
//  SubCategoriesTableViewCell.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 18.08.2021.
//

import UIKit

class SubCategoriesTableViewCell: UITableViewCell {
    
    static let identifier = "subcategoriesCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
