//
//  Timeline.swift
//  saucialApp
//
//  Created by kawayuta on 5/6/21.
//

import Foundation

struct TimelineActivity: Codable, Identifiable {
    let id: Int
    var body: String
    let image: String?
    var images: [Images]?
    let sauna_time: Int
    let sauna_count: Int
    let mizuburo_time: Int
    let mizuburo_count: Int
    let rest_time: Int
    let rest_count: Int
    var user: TimelineUser
    var sauna: TimelineSauna
}


struct TimelineUser: Codable {
    let id: Int
    let username: String
    let name: String?
    let email: String
    let avatar: Avatars?
}

struct TimelineSauna: Codable, Identifiable {
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
    let feed: String?
}
