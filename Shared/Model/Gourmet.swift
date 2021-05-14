//
//  Gourmet.swift
//  saucialApp
//
//  Created by kawayuta on 5/10/21.
//

import Foundation

struct Gourmet: Codable {
    let results: GourmetResults
}
struct GourmetResults: Codable {
    let apiVersion: String
       let resultsAvailable: Int
       let resultsReturned: String
       let resultsStart: Int
       let shop: [GourmetShop]
       
       enum CodingKeys: String, CodingKey {
           case apiVersion = "api_version"
           case resultsAvailable = "results_available"
           case resultsReturned = "results_returned"
           case resultsStart = "results_start"
           case shop
       }
}
struct GourmetShop: Codable, Identifiable {
    let id: String?
    let name: String?
    let logo_image: String?
    let address: String?
    let station_name: String?
    let access: String?
    let open: String?
    let close: String?
//    let party_capacity: String?
    let wifi: String?
    let course: String?
    let free_drink: String?
    let free_food: String?
    let private_room: String?
    let horigotatsu: String?
    let tatami: String?
    let card: String?
    let non_smoking: String?
    let ktai: String?
    let parking: String?
    let lunch: String?
    let midnight: String?
    let lat: Double?
    let lng: Double?
    let genre: GourmetGenre?
    let budget: GourmetBudget?
    let budget_memo: String?
    let urls: GourmetUrls?
    let photo: GourmetPhoto?
    let coupon_urls: GourmetCouponUrls?
}


struct GourmetGenre: Codable {
    let name: String?
}

struct GourmetBudget: Codable {
    let name: String?
    let average: String?
}

struct GourmetBudgetMemo: Codable {
    let name: String?
    let average: String?
}

struct GourmetUrls: Codable {
    let pc: String?
}

struct GourmetPhoto: Codable {
    let pc: GourmetPhotoPC?
    let mobile: GourmetPhotoMobile?
}

struct GourmetPhotoMobile: Codable {
    let l: String?
    let s: String?
}
struct GourmetPhotoPC: Codable {
    let l: String?
    let m: String?
}


struct GourmetCouponUrls: Codable {
    let sp: String?
}
