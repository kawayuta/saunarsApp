//
//  Went.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//

import Foundation

struct WentRequest: Codable {
    let sauna_id: String
}


struct CheckWent: Codable {
    let is_went: Bool?
}

struct Went: Codable {
    let id: Int
    let sauna_id: Int
    let user_id: Int
}
