//
//  ReviewViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 4/24/21.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import URLQueryItemsCoder
import MapKit

final class ReviewViewModel: ObservableObject {
    private let userDefaults = UserDefaults.standard
    
    @Published var keyword = ""
    @Published var saunas:[ReviewSauna] = []
    @StateObject var mapViewModel: MapViewModel
    @State var region: MKCoordinateRegion
    @State var currentRegion: MKCoordinateRegion
    @Published var selectedTab: Int = 0
    
    @Published var saunaColumn = Array(0..<16)
    @Published var saunaRow = Array(0..<6)
    @Published var selectedSaunaColumn = 10
    @Published var selectedSaunaRow = 3
    @Published var mizuColumn = Array(0..<3)
    @Published var mizuRow = Array(0..<6)
    @Published var selectedMizuColumn = 1
    @Published var selectedMizuRow = 3
    @Published var restColumn = Array(0..<30)
    @Published var restRow = Array(0..<6)
    @Published var selectedRestColumn = 10
    @Published var selectedRestRow = 3
    @Published var selectSaunaTitle = ""
    @Published var selectedImages:[UIImage] = []
    
    
    @Published var paramsCleanlinessValue: Int = 3
    @Published var paramsCustomerServiceValue: Int = 3
    @Published var paramsEquipmentValue: Int = 3
    @Published var paramsCustomerMannerValue: Int = 3
    @Published var paramsCostPerformanceValue: Int = 3
    @Published var paramsSaunaId: Int = 0
    @Published var paramsSaunaTime: Int = 0
    @Published var paramsSaunaCount: Int = 0
    @Published var paramsMizuTime: Int = 0
    @Published var paramsMizuCount: Int = 0
    @Published var paramsRestTime: Int = 0
    @Published var paramsRestCount: Int = 0
    @Published var paramsTextArea:String = ""
    @Published var paramsImages:[String] = []
    
    @Published var saunaRoutineValideteState: Bool = true
    @Published var mizuRoutineValideteState: Bool = true
    @Published var restRoutineValideteState: Bool = true
    @Published var textAreaValidateState: Bool = true
    @Published var imagesValidateState: Bool = true
    
    
    init(mapViewModel: MapViewModel) {
        _mapViewModel = StateObject(wrappedValue: mapViewModel)
        region = mapViewModel.region
        currentRegion = mapViewModel.currentRegion
    }
    
    func textAreaValidate() {
        if paramsTextArea.count <= 300 {
            textAreaValidateState = true
        } else {
            textAreaValidateState = false
        }
    }
    
    func imagesValidate() {
        if paramsImages.count <= 2 {
            imagesValidateState = true
        } else {
            imagesValidateState = false
        }
    }
    
    func saunaRoutineValidete() {
        if selectedSaunaColumn == 0 && selectedSaunaRow == 0 { saunaRoutineValideteState = true
            paramsSaunaTime = selectedSaunaColumn
            paramsSaunaCount = selectedSaunaRow
        } else {
            if selectedSaunaColumn == 0 && selectedSaunaRow != 0 ||
                selectedSaunaColumn != 0 && selectedSaunaRow == 0 {
                saunaRoutineValideteState = false
            } else {
                saunaRoutineValideteState = true
                paramsSaunaTime = selectedSaunaColumn
                paramsSaunaCount = selectedSaunaRow
            }
        }
    }
    
    func mizuRoutineValidete() {
        if selectedMizuColumn == 0 && selectedMizuRow == 0 { mizuRoutineValideteState = true
            paramsMizuTime = selectedMizuColumn
            paramsMizuCount = selectedMizuRow
        } else {
            if selectedMizuColumn == 0 && selectedMizuRow != 0 ||
                selectedMizuColumn != 0 && selectedMizuRow == 0 {
                mizuRoutineValideteState = false
            } else {
                mizuRoutineValideteState = true
                paramsMizuTime = selectedMizuColumn
                paramsMizuCount = selectedMizuRow
            }
        }
    }
    
    func restRoutineValidete() {
        if selectedRestColumn == 0 && selectedRestRow == 0 { restRoutineValideteState = true
            paramsRestTime = selectedRestColumn
            paramsRestCount = selectedRestRow
        } else {
            if selectedRestColumn == 0 && selectedRestRow != 0 ||
                selectedRestColumn != 0 && selectedRestRow == 0 {
                restRoutineValideteState = false
            } else {
                restRoutineValideteState = true
                paramsRestTime = selectedRestColumn
                paramsRestCount = selectedRestRow
            }
        }
    }
    
    func setTextDefaultBody() {
        let text = """
        本日は「\(selectSaunaTitle)」に行ってきました！

        ●　ととのいルーティン
        サウナ：　\(paramsSaunaTime)分　✗　\(paramsSaunaCount)回
        水風呂：　\(paramsMizuTime)分　✗　\(paramsMizuCount)回
        休憩：　\(paramsRestTime)分　✗　\(paramsRestCount)回

        ●　施設の評価
        清潔感：　\(paramsCleanlinessValue)点
        接客：　\(paramsCustomerServiceValue)点
        設備：　\(paramsEquipmentValue)点
        お客マナー：　\(paramsCustomerMannerValue)点
        コスパ：　\(paramsCostPerformanceValue)点
        総合評価｜　\((paramsCleanlinessValue +
                                paramsCustomerServiceValue +
                                paramsEquipmentValue +
                                paramsCustomerMannerValue +
                                paramsCostPerformanceValue) * 4)点
        """
        
        paramsTextArea = text
        
    }
    
    
    
    func searchIncrementalSaunaList() {
        let userDefaults = UserDefaults.standard
        
        var urlComponents = URLComponents(string: "\(API.init().host)/saunas/incremental_search")
        urlComponents?.queryItems = [URLQueryItem(name: "name_ja", value: keyword)]
        var queryItems = try! URLQueryItemsEncoder().encode(Property(searchKeyword: keyword))
        
        let queryItemLat = URLQueryItem(name: "latitude", value: String(region.center.latitude))
        let queryItemLon = URLQueryItem(name: "longitude", value: String(region.center.longitude))
        let queryItemCurrentLat = URLQueryItem(name: "currentLatitude", value: String(currentRegion.center.latitude))
        let queryItemCurrentLon = URLQueryItem(name: "currentLongitude", value: String(currentRegion.center.longitude))
        let queryItemRadius = URLQueryItem(name: "radius", value: keyword != "" ? "1000" : "5")
        let queryItemSortType = URLQueryItem(name: "sortType", value: "0") // current region sort
        queryItems.append(queryItemLat)
        queryItems.append(queryItemLon)
        queryItems.append(queryItemCurrentLat)
        queryItems.append(queryItemCurrentLon)
        queryItems.append(queryItemRadius)
        queryItems.append(queryItemSortType)
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url!)!)
        request.httpMethod = "GET"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = userDefaults.string(forKey: "accessToken")
        headers["token-type"] = userDefaults.string(forKey: "tokenType")
        headers["client"] = userDefaults.string(forKey: "client")
        headers["expiry"] = userDefaults.string(forKey: "expiry")
        headers["uid"] = userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
        do {
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode([ReviewSauna].self, from: data)
                            DispatchQueue.main.async {
                                self.saunas = json
                            }
                        } else {
                            print("error")
                        }
                    }
                    
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    
    
    
    
    func postReview(completion: @escaping(Bool) -> Void) {
        let current_user_id = userDefaults.integer(forKey: "current_id")
        let url = URL(string: "\(API.init().host)/reviews.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ReviewRequest(sauna_id: paramsSaunaId,
                                 user_id: current_user_id,
                                 cleanliness: paramsCleanlinessValue,
                                 customer_service: paramsCustomerServiceValue,
                                 equipment: paramsEquipmentValue,
                                 customer_manner: paramsCustomerMannerValue,
                                 cost_performance: paramsCostPerformanceValue)
        
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = userDefaults.string(forKey: "accessToken")
        headers["token-type"] = userDefaults.string(forKey: "tokenType")
        headers["client"] = userDefaults.string(forKey: "client")
        headers["expiry"] = userDefaults.string(forKey: "expiry")
        headers["uid"] = userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        if httpResponse.statusCode == 200 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } catch let error {
                    completion(false)
                    print("エラー")
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func postActivity(completion: @escaping(Bool) -> Void) {
        let current_user_id = userDefaults.integer(forKey: "current_id")
        let url = URL(string: "\(API.init().host)/activities.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let compressionQuality: CGFloat = 0.8
        selectedImages.forEach {
            let image = $0
            let imageData = image.jpegData(compressionQuality: compressionQuality)
            if let imgData = imageData {
                let img = imgData.base64EncodedString()
                paramsImages.append(img)
            }
        }
        
        let body =
        ActivityReviewRequest(sauna_id: paramsSaunaId,
                            user_id: current_user_id,
                            image: "",
                            images: paramsImages,
                            body: paramsTextArea,
                            sauna_time: paramsSaunaTime,
                            sauna_count: paramsSaunaCount,
                            mizuburo_time: paramsMizuTime,
                            mizuburo_count: paramsMizuCount,
                            rest_time: paramsRestTime,
                            rest_count: paramsRestCount,
                            review_attributes:
                                ReviewRequest(
                                    sauna_id: paramsSaunaId,
                                    user_id: current_user_id,
                                    cleanliness: paramsCleanlinessValue,
                                    customer_service: paramsCustomerServiceValue,
                                    equipment: paramsEquipmentValue,
                                    customer_manner: paramsCustomerMannerValue,
                                    cost_performance: paramsCostPerformanceValue
                                )
                            )
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = userDefaults.string(forKey: "accessToken")
        headers["token-type"] = userDefaults.string(forKey: "tokenType")
        headers["client"] = userDefaults.string(forKey: "client")
        headers["expiry"] = userDefaults.string(forKey: "expiry")
        headers["uid"] = userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        
                        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } catch let error {
                    completion(false)
                    print("エラー")
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}

