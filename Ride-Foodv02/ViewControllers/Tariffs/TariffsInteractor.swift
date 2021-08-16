//
//  TariffsInteractor.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 15.06.2021.
//
import Foundation
import UIKit

class TariffsInteractor {
    
    let separetion = SeparetionText()
    
    //Загружаем данные о Тарифах
    func loadTariffs(userID: String, completion: @escaping ([TariffsModel]?) -> Void) {

        let urlString = separetion.separation(input: tariffsURL, insert: userID)
        
        guard let url = URL(string: urlString) else { return }
        
        LoadManager.shared.loadData(of: TariffsDataModel.self,
                                    from: url, httpMethod: .get, passData: nil) { result in
            switch result {
            case .success(let dataModel):
                
                completion(dataModel.data)
            case .failure(let error):
                
                completion(nil)
                print("Tariffs error: \(error.localizedDescription)")
            }
        }
    }
}
