//
//  RecommendViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 4/29/21.
//

import Foundation
import SwiftUI
import Combine
import URLQueryItemsCoder
import MapKit

final class RecommendViewModel: ObservableObject {
    
    @Published var saunas:[Sauna] = []
    @Published var locationSaunas:[Sauna] = []
    let userDefaults = UserDefaults.standard
    var region: MKCoordinateRegion?
    var currentRegion: MKCoordinateRegion?
    @Published var shouldFetch: Bool = false
    
    func swipeDidEnd(saunaIndex: Int) {
        saunas.remove(at: saunaIndex)
    }
    
    func putNotWent(sauna_id: String) {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/wents/\(sauna_id).json")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let body = WentRequest(sauna_id: sauna_id)
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
                            print("went success")
                        } else {
                            print("went error")
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func putWent(sauna_id: String) {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/wents.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = WentRequest(sauna_id: sauna_id)
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
                            print("went success")
                        } else {
                            print("went error")
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func searchLocationSaunaList(writeRegion: Bool, currentLatitude: String, currentLongitude: String) {
        let userDefaults = UserDefaults.standard
        
        var urlComponents = URLComponents(string: "\(API.init().host)/saunas/recommend")
        var queryItems = try! URLQueryItemsEncoder().encode(Property(searchKeyword: " "))
        let queryItemType = URLQueryItem(name: "type", value: "location")
        let queryItemCurrentLatitude = URLQueryItem(name: "currentLatitude", value: currentLatitude)
        let queryItemCurrentLongitude = URLQueryItem(name: "currentLongitude", value: currentLongitude)
        queryItems.append(queryItemType)
        queryItems.append(queryItemCurrentLatitude)
        queryItems.append(queryItemCurrentLongitude)
        urlComponents?.queryItems = queryItems
        
        print(urlComponents)
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
                            let json = try decoder.decode([Sauna].self, from: data)
                            DispatchQueue.main.async {
                                self.locationSaunas = json
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
    
    
    func searchSaunaList(writeRegion: Bool, completion: @escaping(Bool) -> Void) {
        let userDefaults = UserDefaults.standard
        
        var urlComponents = URLComponents(string: "\(API.init().host)/saunas/recommend")
        
        
        var queryItems = try! URLQueryItemsEncoder().encode(Property(searchKeyword: " "))
//        let queryItemLat = URLQueryItem(name: "latitude", value: String(region!.center.latitude))
//        let queryItemLon = URLQueryItem(name: "longitude", value: String(region!.center.longitude))
//        let queryItemCurrentLat = URLQueryItem(name: "currentLatitude", value: String(currentRegion!.center.latitude))
//        let queryItemCurrentLon = URLQueryItem(name: "currentLongitude", value: String(currentRegion!.center.longitude))
        let queryItemRadius = URLQueryItem(name: "radius", value: "1000")
        let queryItemSortType = URLQueryItem(name: "sortType", value: String(SortProperty().sort))
//        queryItems.append(queryItemLat)
//        queryItems.append(queryItemLon)
//        queryItems.append(queryItemCurrentLat)
//        queryItems.append(queryItemCurrentLon)
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
                            let json = try decoder.decode([Sauna].self, from: data)
                            DispatchQueue.main.async {
                                self.saunas = json
                            }
                            
                            completion(true)
                        } else {
                            print("error")
                            completion(false)
                        }
                    }
                    
                    
                } catch let error {
                    print(error)
                    completion(false)
                }
            }
            task.resume()
        }
    }
}
