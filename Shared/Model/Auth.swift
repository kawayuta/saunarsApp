//
//  Auth.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 3/12/21.
//

import Foundation

struct AuthRegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let password_confirmation: String
}


// MARK: - AuthRegisterResponse
struct AuthRegisterResponse: Codable {
    let status: String
    let data: [Auth]
}

struct AuthErrorResponse: Codable {
    let username: String
    let email: String
}

struct AuthResponse: Codable {

    let data: Auth

}

// MARK: - Auth
struct Auth: Codable {

    let id: Int?
    let provider: String?
    let uid: String?
    let allow_password_change: Bool?
    let name: String?
    let username: String?
    let image: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id
        case provider
        case uid
        case allow_password_change
        case name = "name"
        case username = "username"
        case image = "image"
        case email
    }
}
