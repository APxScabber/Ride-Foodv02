//
//  PaymentHistoryModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 12.08.2021.
//

import Foundation

// Модель данных для тарифов
struct PaymentHistoryDataModel: Decodable {
    var data: [PaymentHistoryModel]
}

struct PaymentHistoryModel: Decodable {
    var id: Int
    var paid: Int
    var method: String
    var status: String
    var order: Int
    var payment_card: PaymentCardHistoryModel?
}

struct PaymentCardHistoryModel: Decodable {
    var number: String
    var system: String
}
