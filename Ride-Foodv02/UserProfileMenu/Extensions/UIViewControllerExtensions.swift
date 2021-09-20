//
//  UIViewControllerExtensions.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 01.08.2021.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController{
    func placeIntIntoString(int: Int) -> String{
        guard int != 0 else {
            return ""
        }
        return "\(int)"
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        if #available(iOS 13.0, *) {
            containerView.backgroundColor = .clear
        } else {
            // Fallback on earlier versions
        }
        containerView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        if #available(iOS 13.0, *) {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            activityIndicator.startAnimating()
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func removeChild() {
      self.children.forEach {
        $0.willMove(toParent: nil)
        $0.view.removeFromSuperview()
        $0.removeFromParent()
      }
    }
}
