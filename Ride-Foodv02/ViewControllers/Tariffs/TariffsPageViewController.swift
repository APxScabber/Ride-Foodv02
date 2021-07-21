//
//  TariffsPageViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 18.06.2021.
//

import UIKit

class TariffsPageViewController: UIPageViewController {

    var tariffsModelArray: [TariffsModel]?
    var navigationTitle = "Тарифы"

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        navigationItem.title = navigationTitle

        if let contentVC = showViewController(at: 0) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }

    func showViewController(at index: Int) -> TariffsViewController? {

        guard index >= 0 else { return nil }
        guard index < 3 else { return nil }
            guard let content = storyboard?.instantiateViewController(withIdentifier: "TariffsVC") as? TariffsViewController else { return nil }

        content.indexVC = index
        
        return content
    }
}

extension TariffsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! TariffsViewController).indexVC
        pageNumber -= 1
        
        return showViewController(at: pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! TariffsViewController).indexVC
        pageNumber += 1
        
        return showViewController(at: pageNumber)
    }
}
