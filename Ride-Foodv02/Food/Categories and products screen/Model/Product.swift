//
//  Product.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 16.08.2021.
//

import Foundation

// MARK: - Product
struct ProductData: Codable {
    var data: [Product]?
    var links: Links?
    var meta: Meta?
}

// MARK: - Datum
struct Product: Codable {
    var id: Int?
    var name: String?
    var icon: String?
    var isCategory: Bool?
    var price: Int?
    var producing: String?
    var hit: Int?
    var sale: Int?
    var composition: String?
    var weight: Int?
    var unit: String?
}

// MARK: - Links
struct Links: Codable {
    var first: String?
    var last: String?
    var prev: String?
    var next: String?
}

// MARK: - Meta
struct Meta: Codable {
    var currentPage: Int?
    var from: Int?
    var lastPage: Int?
    var path: String?
    var perPage: Int?
    var to: Int?
    var total: Int?
}
