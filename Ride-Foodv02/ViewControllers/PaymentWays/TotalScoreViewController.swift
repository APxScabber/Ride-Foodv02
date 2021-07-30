//
//  TotalScoreViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 29.07.2021.
//

import UIKit

class TotalScoreViewController: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var newOrderButtonOutlet: UIButton!
    @IBOutlet weak var moreDetailsButtonOutlet: UIButton!
    
    // MARK: - Properties
    
    var userID: String?
    let totalScoresInteractor = TotalScoresInteractor()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        infoTextView.text = ""
        getScores()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        //infoTextView.font = UIFont.SFUIDisplayRegular(size: 23)
        //infoTextView.textAlignment = .center
        newOrderButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        moreDetailsButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
    }
    
    private func getScores() {
        
        guard let userID = userID else { return }
        
        totalScoresInteractor.loadScores(userID: userID) { data in
            
            let totalScores = String(data.credit)
            let finalText = self.totalScoresInteractor.separatedTotal(scores: totalScores,
                                                                      text: TotalScoresViewText.infoTitle.text())
            
           let textAttribute = self.totalScoresInteractor.createTextAttribute(for: finalText)
        
            DispatchQueue.main.async {
                
                self.infoTextView.attributedText = textAttribute
                self.infoTextView.font = UIFont.SFUIDisplayRegular(size: 19)
                self.infoTextView.textAlignment = .center
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func newOrderButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainScreenViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
