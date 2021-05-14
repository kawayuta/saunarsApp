//
//  Like.swift
//  saucialApp
//
//  Created by kawayuta on 5/9/21.
//

import Foundation

struct LikeRequest: Codable {
    let activity_id: String
}


struct CheckLike: Codable {
    let is_like: Bool?
    let like_count: Int
}

struct Like: Codable {
    let id: Int
    let activity_id: Int
    let user_id: Int
}
