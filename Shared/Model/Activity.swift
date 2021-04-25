//
//  Activity.swift
//  saucialApp
//
//  Created by kawayuta on 4/24/21.
//

import Foundation


struct ActivityReviewRequest: Codable {
    let sauna_id: Int
    let user_id: Int
    let image: String?
    let body: String
    let sauna_time: Int
    let sauna_count: Int
    let mizuburo_time: Int
    let mizuburo_count: Int
    let rest_time: Int
    let rest_count: Int
    let review_attributes: ReviewRequest
}


struct deleteActivityRequest: Codable {
    let activity_id: Int
}


struct Activity: Codable, Identifiable {
    let id: Int
    let body: String
    let image: String?
    let sauna_time: Int
    let sauna_count: Int
    let mizuburo_time: Int
    let mizuburo_count: Int
    let rest_time: Int
    let rest_count: Int
}
