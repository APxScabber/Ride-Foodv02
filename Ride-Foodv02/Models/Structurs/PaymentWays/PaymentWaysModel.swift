//
//  PaymentWaysModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 30.06.2021.
//

import Foundation

// Модель данных для тарифов
struct PaymentWaysDataModel: Decodable {
    var data: [PaymentWaysModel]
}

struct PaymentWaysModel: Decodable {
    var id: Int
    var number: String
    var expiry_date: String
    var status: String
}

struct PaymentWaysResponseData: Decodable {
    var data: PaymentWaysModel
}

struct ErrorAddCard: Decodable {
    var error: String
}
