

import Foundation

// MARK: - OrderData
struct OrderData: Codable {
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    var id: Int?
    var userid: Int?
    var from: String?
    var to: String?
    var credit: Int?
    var distance: Int?
    var price: Int?
    var discount: Int?
    var forPayment: Int?
    var type: String?
    var status: String?
    var comment: Comment?
    var tariff: Tariff?
    var promoCodes: [PromoCode]?
    var availablePromoCodes: [PromoCode]?
    var taxi: Taxi?
    var products: [Food]?
}

// MARK: - PromoCode
struct PromoCode: Codable {
    var id: Int
    var code: String
    var validity: String
    var dateActivation: String
    var used: Bool
    var promoCodeDescription: String
    var shortDescription: String
    var sale: Int
}

// MARK: - Comment
struct Comment: Codable {
}

// MARK: - Product
struct Food: Codable {
    var id: Int
    var name: String
    var price: Int
    var sale: Int
    var hit: Bool
    var composition: String
    var weight: Int
    var unit: String
    var producing: String
    var image: String
}

// MARK: - Tariff
struct Tariff: Codable {
    var id: Int
    var name: String
    var cars: String
    var tariffDescription: String
    var icon: String
}

// MARK: - Taxi
struct Taxi: Codable {
    var id: Int
    var car: String
    var color: String
    var number: String
    var regionNumber: Int
    var imageMap: String
    var imageOrder: String
    var imageHistory: String
}

