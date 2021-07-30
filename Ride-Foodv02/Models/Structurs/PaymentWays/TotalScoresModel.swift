//
//  TotalScoresModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.07.2021.
//

import Foundation

// Модель данных для тарифов
struct TotalScoresDataModel: Decodable {
    var data: TotalScoresModel
}

struct TotalScoresModel: Decodable {
    var credit: Int
}
