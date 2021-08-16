//
//  TotalScoresInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.07.2021.
//

import Foundation
import UIKit

class TotalScoresInteractor {
    
    let separetion = SeparetionText()
    
    func loadScores(userID: String, completion: @escaping (TotalScoresModel) -> Void) {
        
        let stringURL = separetion.separation(input: totalScoresURL, insert: userID)
        
        let url = URL(string: stringURL)
        
        LoadManager.shared.loadData(of: TotalScoresDataModel.self, from: url!,
                                    httpMethod: .get, passData: nil) { result in
            
            switch result {
            case .success(let model):
                completion(model.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
