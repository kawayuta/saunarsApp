//
//  Review.swift
//  saucialApp
//
//  Created by kawayuta on 4/24/21.
//

import Foundation

struct ReviewRequest: Codable {
    let sauna_id: Int
    let user_id: Int
    let cleanliness: Int
    let customer_service: Int
    let equipment: Int
    let customer_manner: Int
    let cost_performance: Int
}

struct ReviewSauna: Codable, Identifiable {
    let id: Int
    let name_ja: String
    let image: Images
    let address: String
    let tel: String
    let hp: String
    let price: Int
    let parking: String
    let latitude: Double?
    let longitude: Double?
}

struct Review: Codable, Identifiable {
    let id: Int
    let cleanliness: Int
    let customer_service: Int
    let equipment: Int
    let customer_manner: Int
    let cost_performance: Int
}
