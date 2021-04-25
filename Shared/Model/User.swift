//
//  User.swift
//  saucialApp
//
//  Created by kawayuta on 4/22/21.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    let wents: [WentSauna]
    let activities: [Activity]
    let activities_reviews: [Review]
    let activities_saunas: [ReviewSauna]
}

struct WentSauna: Codable, Identifiable {
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
