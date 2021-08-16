//
//  TotalScoreViewController.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 29.07.2021.
//

import UIKit

class TotalScoreViewController: BaseViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var newOrderButtonOutlet: UIButton!
    @IBOutlet weak var moreDetailsButtonOutlet: UIButton!
    @IBOutlet weak var topRoundedView: TopRoundedView!
    
    // MARK: - Properties
    
    //var userID = GetUserIDManager.shared.userID
    var isMoreDetailsLoad = false
    let totalScoresInteractor = TotalScoresInteractor()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserID()
        
        setupUI()
        infoTextView.text = ""
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
        
        newOrderButtonOutlet.style()
        newOrderButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        moreDetailsButtonOutlet.titleLabel?.font = UIFont.SFUIDisplayRegular(size: 17)
        
        newOrderButtonOutlet.setTitle(AddScoresViewText.newOrder.text(), for: .normal)
        newOrderButtonOutlet.backgroundColor = TariffsColors.blueColor.value
        moreDetailsButtonOutlet.setTitle(AddScoresViewText.moreDetails.text(), for: .normal)
    }
    
    private func getScores() {
        
        guard let userID = userID else { return }
        
        totalScoresInteractor.loadScores(userID: userID) { data in
            
            let totalScores = String(data.credit)
            
            let finalText = self.totalScoresInteractor.separetion.separation(input: TotalScoresViewText.infoTitle.text(), insert: totalScores)
            let textCount = finalText.count
            let typeAttributeText: [NSAttributedString.Key : Any] = [.foregroundColor : PaymentWaysColors.yellowColor.value]
            let textAttribute = self.createTextAttribute(inputText: finalText, type: typeAttributeText,
                                                       locRus: 6, lenRus: textCount - 6,
                                                       locEng: 9, lenEng: textCount - 9)
            
            DispatchQueue.main.async {
                
                self.infoTextView.attributedText = textAttribute
                self.infoTextView.font = UIFont.SFUIDisplayRegular(size: 19)
                self.infoTextView.textAlignment = .center
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
        dismiss(animated: true)
    }
}
