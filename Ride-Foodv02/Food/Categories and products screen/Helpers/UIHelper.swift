//
//  UIHelper.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 18.08.2021.
//

import UIKit

struct UIHelper {
    static func createHorizontalCollectionViewFlowLayout(in view: UIView) -> UICollectionViewFlowLayout{
        
        let padding: CGFloat = 8
        let minimumItemSpacing: CGFloat = 3
       
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = CGSize(width: 30, height: 10)
         flowLayout.minimumLineSpacing = minimumItemSpacing
         flowLayout.minimumInteritemSpacing = minimumItemSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding + 18, bottom: padding, right: padding)
        
        return flowLayout
    }
    
    static func createProductsCollectionViewFlowLayour(in view: UIView) -> UICollectionViewFlowLayout{
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 2
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 60)
        
        return flowLayout
    }
}
