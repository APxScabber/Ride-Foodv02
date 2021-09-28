//
//  VBTextView.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.07.2021.
//

import UIKit

class VBTextView: UIView {
    
    public var textView = UITextField()
    
    public var bottomView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        textView.translatesAutoresizingMaskIntoConstraints   = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.adjustsFontSizeToFitWidth = true
        textView.minimumFontSize = 10
        
        bottomView.backgroundColor                  = UIColor.ProfileButtonBorderColor
        textView.textColor                          = UIColor.black
        
        
        textView.font = UIFont.SFUIDisplayRegular(size: 17)
        
        addSubview(bottomView)
        addSubview(textView)
       
        
        let textViewPadding: CGFloat                = 7
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1),
            
            
            textView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -textViewPadding),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textViewPadding-4),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textViewPadding),
            textView.heightAnchor.constraint(equalToConstant: 30),
            
           
            
        ])
    }
  

}
