//
//  User.swift
//  saucialApp
//
//  Created by kawayuta on 4/22/21.
//

import Foundation

struct UserUpdateRequest: Codable {
    let avatar: String
    let name: String
    let username: String
}

struct UserRegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let password_confirmation: String
    let current_password: String
}

struct UserUpdatePassWordRequest: Codable {
    let password: String
    let password_confirmation: String
}

struct User: Codable {
    let id: Int
    let username: String
    let name: String?
    let email: String
    let avatar: Avatars?
    let wents: [WentSauna]
    let activities: [Activity]
    let activities_reviews: [Review]
    let activities_saunas: [ReviewSauna]
    let activities_month: [Activity]
}
struct Avatars: Codable {
    var url: String?
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
