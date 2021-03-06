//
//  Went.swift
//  saucialApp
//
//  Created by kawayuta on 3/13/21.
//

import Foundation
let userDefault = UserDefaults.standard
struct Saunas: Codable, Identifiable {
    let id: Int
    let name_ja: String
    let url: String
    let image: Images
    let is_went: Bool
    let address: String
    let tel: String
    let hp: String
    let price: Int
    let parking: String
    let rooms : [Rooms]
    let roles : [Roles]
    let amenities : [Amenities]
    let latitude: Double?
    let longitude: Double?
    let feed: String?
}

struct Images: Codable {
    var url: String
}




struct Rooms: Codable, Identifiable {
    var id: Int
    var sauna_temperature: Int?
    var mizu_temperature: Int?
    var gender: Int
}

struct Roles: Codable, Identifiable {
    var id: Int
    var loyly: Bool
    var auto_loyly: Bool
    var self_loyly: Bool
    var gaikiyoku: Bool
    var rest_space: Bool
    var free_time: Bool
    var capsule_hotel: Bool
    var in_rest_space: Bool
    var eat_space: Bool
    var wifi: Bool
    var power_source: Bool
    var work_space: Bool
    var manga: Bool
    var body_care: Bool
    var body_towel: Bool
    var water_dispenser: Bool
    var washlet: Bool
    var credit_settlement: Bool
    var parking_area: Bool
    var ganbanyoku: Bool
    var tattoo: Bool
 
    func trueCount() -> Int {
        var count = 0
        if loyly == true { count += 1 }
        if auto_loyly == true { count += 1 }
        if self_loyly == true { count += 1 }
        if free_time == true { count += 1 }
        if capsule_hotel == true { count += 1 }
        if rest_space == true { count += 1 } //
        if in_rest_space == true { count += 1 } //
        if eat_space == true { count += 1 }
        if wifi == true { count += 1 }
        if power_source == true { count += 1 }
        if work_space == true { count += 1 }
        if manga == true { count += 1 }
        if body_care == true { count += 1 }
        if body_towel == true { count += 1 }
        if water_dispenser == true { count += 1 }
        if washlet == true { count += 1 }
        if credit_settlement == true { count += 1 }
        if parking_area == true { count += 1 }
        if ganbanyoku == true { count += 1 }
        if gaikiyoku == true { count += 1 } //
        if tattoo == true { count += 1 }
        
        return count
    }
}


struct Amenities: Codable, Identifiable {
    var id: Int
    var shampoo: Bool
    var conditioner: Bool
    var body_soap: Bool
    var face_soap: Bool
    var razor: Bool
    var toothbrush: Bool
    var nylon_towel: Bool
    var hairdryer: Bool
    var face_towel_unlimited: Bool
    var bath_towel_unlimited: Bool
    var sauna_underpants_unlimited: Bool
    var sauna_mat_unlimited: Bool
    var flutterboard_unlimited: Bool
    var toner: Bool
    var emulsion: Bool
    var makeup_remover: Bool
    var cotton_swab: Bool
 
    func trueCount() -> Int {
        var count = 0
        if shampoo == true { count += 1 }
        if conditioner == true { count += 1 }
        if body_soap == true { count += 1 }
        if face_soap == true { count += 1 }
        if razor == true { count += 1 }
        if toothbrush == true { count += 1 }
        if nylon_towel == true { count += 1 }
        if hairdryer == true { count += 1 }
        if face_towel_unlimited == true { count += 1 }
        if bath_towel_unlimited == true { count += 1 }
        if sauna_underpants_unlimited == true { count += 1 }
        if sauna_mat_unlimited == true { count += 1 }
        if flutterboard_unlimited == true { count += 1 }
        if toner == true { count += 1 }
        if emulsion == true { count += 1 }
        if makeup_remover == true { count += 1 }
        if cotton_swab == true { count += 1 }
        
        return count
    }
}




struct Sauna: Codable, Identifiable {
    let id: Int
    let name_ja: String
    let url: String
    let image: Images
    var is_went: Bool
    let address: String
    let tel: String
    let hp: String
    let price: Int
    let parking: String
    let rooms : [Rooms]
    let roles : [Roles]
    let amenities : [Amenities]
    let latitude: Double?
    let longitude: Double?
    let reviews: [Review]
    let feed: String?
    let holiday: String?
}


struct SaunaTags: Codable, Identifiable {
    var id: Int?
    var title: String
}

struct SaunaSearchRequest: Codable {
    let name_ja: String
}

struct SortProperty: Encodable {
    var sort:Int = 0
    
    init() {
        sort = (userDefault.integer(forKey: "sortType") != 0) ? userDefault.integer(forKey: "sortType") : 0
    }
}


struct Property: Encodable {
    var q = Q()
       struct Q: Encodable {
        var name_ja_or_address_cont = ""
        var sauna_roles_loyly_eq: Bool?
        var sauna_roles_self_loyly_eq: Bool?
        var sauna_roles_auto_loyly_eq: Bool?
        var sauna_tags_title_cont = ""
        var sauna_roles_gaikiyoku_cont: Bool?
        var sauna_roles_rest_space_cont: Bool?
        
        var sauna_roles_free_time_cont: Bool?
        var sauna_roles_capsule_hotele_cont: Bool?
        var sauna_roles_in_rest_space_cont: Bool?
        var sauna_roles_eat_space_cont: Bool?
        var sauna_roles_wifi_cont: Bool?
        var sauna_roles_power_source_cont: Bool?
        var sauna_roles_work_space_cont: Bool?
        var sauna_roles_manga_cont: Bool?
        var sauna_roles_body_care_cont: Bool?
        var sauna_roles_body_towel_cont: Bool?
        var sauna_roles_water_dispenser_cont: Bool?
        var sauna_roles_washlet_cont: Bool?
        var sauna_roles_credit_settlement_cont: Bool?
        var sauna_roles_parking_area_cont: Bool?
        var sauna_roles_ganbanyoku_cont: Bool?
        var sauna_roles_tattoo_cont: Bool?
        
        var sauna_amenities_shampoo_cont: Bool?
        var sauna_amenities_conditioner_cont: Bool?
        var sauna_amenities_body_soap_cont: Bool?
        var sauna_amenities_face_soap_cont: Bool?
        var sauna_amenities_razor_cont: Bool?
        var sauna_amenities_toothbrush_cont: Bool?
        var sauna_amenities_nylon_towel_cont: Bool?
        var sauna_amenities_hairdryer_cont: Bool?
        var sauna_amenities_face_towel_unlimited_cont: Bool?
        var sauna_amenities_bath_towel_unlimited_cont: Bool?
        var sauna_amenities_sauna_underpants_unlimited_cont: Bool?
        var sauna_amenities_sauna_mat_unlimited_cont: Bool?
        var sauna_amenities_flutterboard_unlimited_cont: Bool?
        var sauna_amenities_toner_cont: Bool?
        var sauna_amenities_emulsion_cont: Bool?
        var sauna_amenities_makeup_remover_cont: Bool?
        var sauna_amenities_cotton_swab_cont: Bool?
       }
    
    init(searchKeyword: String) {
        q.name_ja_or_address_cont = searchKeyword
        q.sauna_roles_loyly_eq = userDefault.bool(forKey: "loyly") ? true : nil
        q.sauna_roles_self_loyly_eq = userDefault.bool(forKey: "selfLoyly") ? true : nil
        q.sauna_roles_auto_loyly_eq = userDefault.bool(forKey: "autoLoyly") ? true : nil
        q.sauna_tags_title_cont = userDefault.string(forKey: "tagTitle") == nil ? "" : userDefault.string(forKey: "tagTitle")!
        q.sauna_roles_gaikiyoku_cont = userDefault.bool(forKey: "gaikiYoku") ? true : nil
        q.sauna_roles_rest_space_cont = userDefault.bool(forKey: "restSpace") ? true : nil
        
        q.sauna_roles_free_time_cont = userDefault.bool(forKey: "freeTime") ? true : nil
        q.sauna_roles_capsule_hotele_cont = userDefault.bool(forKey: "capsuleHotel") ? true : nil
        q.sauna_roles_in_rest_space_cont = userDefault.bool(forKey: "inRestSpace") ? true : nil
        q.sauna_roles_eat_space_cont = userDefault.bool(forKey: "eatSpace") ? true : nil
        q.sauna_roles_wifi_cont = userDefault.bool(forKey: "wifi") ? true : nil
        q.sauna_roles_power_source_cont = userDefault.bool(forKey: "powerSource") ? true : nil
        q.sauna_roles_work_space_cont = userDefault.bool(forKey: "workSpace") ? true : nil
        q.sauna_roles_manga_cont = userDefault.bool(forKey: "manga") ? true : nil
        q.sauna_roles_body_care_cont = userDefault.bool(forKey: "bodyCare") ? true : nil
        q.sauna_roles_body_towel_cont = userDefault.bool(forKey: "bodyTowel") ? true : nil
        q.sauna_roles_water_dispenser_cont = userDefault.bool(forKey: "waterDispenser") ? true : nil
        q.sauna_roles_washlet_cont = userDefault.bool(forKey: "washlet") ? true : nil
        q.sauna_roles_credit_settlement_cont = userDefault.bool(forKey: "creditSettlement") ? true : nil
        q.sauna_roles_parking_area_cont = userDefault.bool(forKey: "parkingArea") ? true : nil
        q.sauna_roles_ganbanyoku_cont = userDefault.bool(forKey: "ganbanYoku") ? true : nil
        q.sauna_roles_tattoo_cont = userDefault.bool(forKey: "tattoo") ? true : nil
        
        q.sauna_amenities_shampoo_cont = userDefault.bool(forKey: "shampoo") ? true : nil
        q.sauna_amenities_conditioner_cont = userDefault.bool(forKey: "conditioner") ? true : nil
        q.sauna_amenities_body_soap_cont = userDefault.bool(forKey: "bodySoap") ? true : nil
        q.sauna_amenities_face_soap_cont = userDefault.bool(forKey: "faceSoap") ? true : nil
        q.sauna_amenities_razor_cont = userDefault.bool(forKey: "razor") ? true : nil
        q.sauna_amenities_toothbrush_cont = userDefault.bool(forKey: "toothbrush") ? true : nil
        q.sauna_amenities_nylon_towel_cont = userDefault.bool(forKey: "nylonTowel") ? true : nil
        q.sauna_amenities_hairdryer_cont = userDefault.bool(forKey: "hairDryer") ? true : nil
        q.sauna_amenities_face_towel_unlimited_cont = userDefault.bool(forKey: "faceTowelUnlimited") ? true : nil
        q.sauna_amenities_bath_towel_unlimited_cont = userDefault.bool(forKey: "bathTowelUnlimited") ? true : nil
        q.sauna_amenities_sauna_underpants_unlimited_cont = userDefault.bool(forKey: "saunaUnderpantsUnlimited") ? true : nil
        q.sauna_amenities_sauna_mat_unlimited_cont = userDefault.bool(forKey: "saunaMatUnlimited") ? true : nil
        q.sauna_amenities_flutterboard_unlimited_cont = userDefault.bool(forKey: "flutterboardUnlimited") ? true : nil
        q.sauna_amenities_toner_cont = userDefault.bool(forKey: "toner") ? true : nil
        q.sauna_amenities_emulsion_cont = userDefault.bool(forKey: "emulsion") ? true : nil
        q.sauna_amenities_makeup_remover_cont = userDefault.bool(forKey: "makeupRemover") ? true : nil
        q.sauna_amenities_cotton_swab_cont = userDefault.bool(forKey: "cottonSwab") ? true : nil
    }
}


struct SearchOptions: Identifiable {
    let id = UUID()
    var optionValidState = false
    var saunaTypeTagList = ["?????????", "?????????", "????????????", "??????", "???", "?????????"]
    
    var rolesList = [
        "freeTime": "24????????????",
        "capsuleHotel": "?????????????????????",
        "inRestSpace" : "????????????????????????",
        "eatSpace": "?????????",
        "wifi": "WiFi",
        "powerSource": "??????",
        "workSpace": "??????????????????",
        "manga": "??????",
        "bodyCare": "???????????????",
        "bodyTowel": "??????????????????",
        "waterDispenser": "?????????",
        "washlet": "?????????????????????",
        "creditSettlement": "?????????????????????",
        "parkingArea": "?????????",
        "ganbanYoku": "?????????",
        "tattoo": "????????????OK"
    ]
    var rolesState: [String:Bool?]
    
    var amenityList = [
        "shampoo": "???????????????",
        "conditioner": "????????????????????????",
        "bodySoap": "??????????????????",
        "faceSoap": "?????????????????????",
        "razor": "????????????",
        "toothbrush": "????????????",
        "nylonTowel": "?????????????????????",
        "hairDryer": "?????????????????????",
        "faceTowelUnlimited": "?????????????????????",
        "bathTowelUnlimited": "???????????????",
        "saunaUnderpantsUnlimited": "??????????????????",
        "saunaMatUnlimited": "??????????????????",
        "flutterboardUnlimited": "????????????",
        "toner": "?????????",
        "emulsion": "??????",
        "makeupRemover": "??????????????????",
        "cottonSwab": "??????",
    ]
    var amenityState: [String:Bool?]
    
    
    var loyly: Bool?
    var autoLoyly: Bool?
    var selfLoyly: Bool?
    var tagTitle: String?
    var gaikiYoku: Bool?
    var restSpace: Bool?
    
     init() {
        //init
        
//      reco
        loyly = userDefault.bool(forKey: "loyly")
        selfLoyly = userDefault.bool(forKey: "selfLoyly")
        autoLoyly = userDefault.bool(forKey: "autoLoyly")
        tagTitle = userDefault.string(forKey: "tagTitle")
        gaikiYoku = userDefault.bool(forKey: "gaikiYoku")
        restSpace = userDefault.bool(forKey: "restSpace")
        
//      role
        rolesState = [
            "freeTime": userDefault.bool(forKey: "freeTime"),
            "capsuleHotel": userDefault.bool(forKey: "capsuleHotel"),
            "inRestSpace" : userDefault.bool(forKey: "inRestSpace"),
            "eatSpace": userDefault.bool(forKey: "eatSpace"),
            "wifi": userDefault.bool(forKey: "wifi"),
            "powerSource": userDefault.bool(forKey: "powerSource"),
            "workSpace": userDefault.bool(forKey: "workSpace"),
            "manga": userDefault.bool(forKey: "manga"),
            "bodyCare": userDefault.bool(forKey: "bodyCare"),
            "bodyTowel": userDefault.bool(forKey: "bodyTowel"),
            "waterDispenser": userDefault.bool(forKey: "waterDispenser"),
            "washlet": userDefault.bool(forKey: "washlet"),
            "creditSettlement": userDefault.bool(forKey: "creditSettlement"),
            "parkingArea": userDefault.bool(forKey: "parkingArea"),
            "ganbanYoku": userDefault.bool(forKey: "ganbanYoku"),
            "tattoo": userDefault.bool(forKey: "tattoo")
        ]
        
        
//      amenity
        amenityState = [
            "shampoo": userDefault.bool(forKey: "shampoo"),
            "conditioner": userDefault.bool(forKey: "conditioner"),
            "bodySoap": userDefault.bool(forKey: "bodySoap"),
            "faceSoap": userDefault.bool(forKey: "faceSoap"),
            "razor": userDefault.bool(forKey: "razor"),
            "toothbrush": userDefault.bool(forKey: "toothbrush"),
            "nylonTowel": userDefault.bool(forKey: "nylonTowel"),
            "hairDryer": userDefault.bool(forKey: "hairDryer"),
            "faceTowelUnlimited": userDefault.bool(forKey: "faceTowelUnlimited"),
            "bathTowelUnlimited": userDefault.bool(forKey: "bathTowelUnlimited"),
            "saunaUnderpantsUnlimited": userDefault.bool(forKey: "saunaUnderpantsUnlimited"),
            "saunaMatUnlimited": userDefault.bool(forKey: "saunaMatUnlimited"),
            "flutterboardUnlimited": userDefault.bool(forKey: "flutterboardUnlimited"),
            "toner": userDefault.bool(forKey: "toner"),
            "emulsion": userDefault.bool(forKey: "emulsion"),
            "makeupRemover": userDefault.bool(forKey: "makeupRemover"),
            "cottonSwab": userDefault.bool(forKey: "cottonSwab")
        ]
        
        optionValidCheck()
     }
    
    mutating func optionValidCheck() {
        if
            tagTitle == ""  &&
                
            !loyly! &&
            !autoLoyly! &&
            !selfLoyly! &&
            !gaikiYoku! &&
            !restSpace! &&
                
            !rolesState["freeTime"]!! &&
            !rolesState["capsuleHotel"]!! &&
            !rolesState["inRestSpace"]!! &&
            !rolesState["eatSpace"]!! &&
            !rolesState["wifi"]!! &&
            !rolesState["powerSource"]!! &&
            !rolesState["workSpace"]!! &&
            !rolesState["manga"]!! &&
            !rolesState["bodyCare"]!! &&
            !rolesState["bodyTowel"]!! &&
            !rolesState["waterDispenser"]!! &&
            !rolesState["washlet"]!! &&
            !rolesState["creditSettlement"]!! &&
            !rolesState["parkingArea"]!! &&
            !rolesState["ganbanYoku"]!! &&
            !rolesState["tattoo"]!! &&
                
            !amenityState["shampoo"]!! &&
            !amenityState["conditioner"]!! &&
            !amenityState["bodySoap"]!! &&
            !amenityState["faceSoap"]!! &&
            !amenityState["razor"]!! &&
            !amenityState["toothbrush"]!! &&
            !amenityState["nylonTowel"]!! &&
            !amenityState["hairDryer"]!! &&
            !amenityState["faceTowelUnlimited"]!! &&
            !amenityState["bathTowelUnlimited"]!! &&
            !amenityState["saunaUnderpantsUnlimited"]!! &&
            !amenityState["saunaMatUnlimited"]!! &&
            !amenityState["flutterboardUnlimited"]!! &&
            !amenityState["toner"]!! &&
            !amenityState["emulsion"]!! &&
            !amenityState["makeupRemover"]!! &&
            !amenityState["cottonSwab"]!!
        {
            optionValidState = false
        } else {
            optionValidState = true
        }
    }
}

