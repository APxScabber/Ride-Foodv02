//
//  ConfirmModel.swift
//  Ride-Foodv02
//
//  Created by Alexey Peshekhonov on 07.06.2021.
//

import Foundation

//Модель данных для кода подтверждения
struct DataConfirmModel: Decodable {
    var data: ConfirmModel
}

struct ConfirmModel: Decodable {
    var code: Int
}
