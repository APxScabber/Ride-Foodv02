//
//  CongratulationsScoresViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 03.08.2021.
//

import UIKit

class CongratulationsScoresViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var congratulationsLabel: UILabel!
    @IBOutlet weak var youHaveTextView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var newOrderButtonOutlet: UIButton!
    @IBOutlet weak var moreDetailsButtonOutlet: UIButton!
    
    // MARK: - Properties
    
    var userID: String?
    
    var isMoreDetailsLoad = false
    
    let totalScoresInteractor = TotalScoresInteractor()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getScores()
    }
    
    // MARK: - viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMoreDetailsLoad {
            let storyboard = UIStoryboard(name: "PaymentWays", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MoreDetails") as! MoreDetailsViewController
            presentingViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        
        congratulationsLabel.font = UIFont.SFUIDisplayRegular(size: 17)
        infoLabel.font = UIFont.SFUIDisplayRegular(size: 12)
        infoLabel.textColor = PaymentWaysColors.grayColor.value
        newOrderButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        moreDetailsButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        
        congratulationsLabel.text = AddScoresViewText.congratulations.text()
        infoLabel.text = AddScoresViewText.scoresInfo.text()
        newOrderButtonOutlet.style()
        newOrderButtonOutlet.setTitle(AddScoresViewText.newOrder.text(), for: .normal)
        newOrderButtonOutlet.backgroundColor = TariffsColors.blueColor.value
        moreDetailsButtonOutlet.setTitle(AddScoresViewText.moreDetails.text(), for: .normal)

    }
    
    private func getScores() {
        
        guard let userID = userID else { return }
        
        totalScoresInteractor.loadScores(userID: userID) { data in
            
            let totalScores = String(data.credit)
            let finalText = self.totalScoresInteractor.separatedTotal(scores: totalScores,
                                                                      text: AddScoresViewText.youHave.text())
            
           let textAttribute = self.totalScoresInteractor.createTextAttribute(for: finalText)
        
            DispatchQueue.main.async {
                
                self.youHaveTextView.attributedText = textAttribute
                self.youHaveTextView.font = UIFont.SFUIDisplayRegular(size: 19)
                self.youHaveTextView.textAlignment = .center
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func newOrderButtonAction(_ sender: Any) {
        isMoreDetailsLoad = false
        view.window!.rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func moreDetailsButtonAction(_ sender: Any) {
        isMoreDetailsLoad = true
        dismiss(animated: true, completion: nil)
    }
}
