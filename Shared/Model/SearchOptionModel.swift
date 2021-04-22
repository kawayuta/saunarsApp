//
//  SearchOptionModel.swift
//  saucialApp
//
//  Created by kawayuta on 3/23/21.
//

import Foundation

struct SearchOptions: Identifiable {
    let id = UUID()
    var loyly: Bool?
    var autoLoyly: Bool?
    var selfLoyly: Bool?
    var tagTitle: String?
    
     init() {
        loyly = UserDefaults.standard.bool(forKey: "loyly")
        autoLoyly = UserDefaults.standard.bool(forKey: "autoLoyly")
        selfLoyly = UserDefaults.standard.bool(forKey: "selfLoyly")
        tagTitle = UserDefaults.standard.string(forKey: "tagTitle")
     }
}
