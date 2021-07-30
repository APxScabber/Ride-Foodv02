//
//  TariffsModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 17.06.2021.
//

import Foundation

// Модель данных для тарифов
struct TariffsDataModel: Decodable {
    var data: [TariffsModel]
}

struct TariffsModel: Decodable {
    var id: Int
    var name: String
    var cars: String
    var description: String
    var icon: String
    var advantages: [AdvantagesModel]
    
}

struct  AdvantagesModel: Decodable {
    var name: String
    var icon: String
}
