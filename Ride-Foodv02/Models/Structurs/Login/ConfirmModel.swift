//
//  ConfirmResponsesModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 09.06.2021.
//

import Foundation

// Модель данных принимаемвя с сервера при успешной регистрации
struct ConfirmResponsesModel: Decodable {
    var data: ConfirmModel
}

struct ConfirmModel: Decodable {
    var id: Int
    var name: String?
    var email: String?
    var created_at: Int
    var updated_at: Int
    var deleted_at: Int?
    var setting: ConfirmSettings?
}

struct  ConfirmSettings: Decodable {
    var language: String
    var do_not_call: Bool
    var notification_discount: Bool
    var update_mobile_network: Bool
}
