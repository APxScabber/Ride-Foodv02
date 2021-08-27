//
//  CartVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 27.08.2021.
//

import UIKit

class CartVC: UIViewController {
    
    var productsInCart: [FoodOrderMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiaryLabel
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = .systemTeal
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: view.frame.size.height, height: 2200)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
