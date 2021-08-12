//
//  TariffsPageExtensions.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 13.08.2021.
//

import Foundation
import UIKit

// MARK: - Extensions
extension TariffsPageViewController: UIPageViewControllerDataSource {
    
    // Функция отвечающая за переход на предыдщую страницу
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! TariffsViewController).indexVC
        pageNumber -= 1
        
        return showViewController(at: pageNumber)
    }
    
    // Функция отвечающая за переход на следующую страницу
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! TariffsViewController).indexVC
        pageNumber += 1
        
        return showViewController(at: pageNumber)
    }
}
