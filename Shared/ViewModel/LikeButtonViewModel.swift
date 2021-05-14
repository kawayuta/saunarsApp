//
//  LikeButtonViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 5/9/21.
//

import Foundation
import SwiftUI

final class LikeButtonViewModel: ObservableObject {
    
    @Published var state: Bool = false
    @Published var like_count: Int = 0
    @Published var activity_id: String
    
    init(activity_id: String) {
        self.activity_id = activity_id
    }
}


extension LikeButtonViewModel {
    
    func fetchLike() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/likes/\(activity_id).json")
        var request = URLRequest(url: url!)
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

                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(CheckLike.self, from: data)
                            
                                DispatchQueue.main.async {
                                    if let is_like = json.is_like {
                                        state = is_like
                                    }
                                    like_count = json.like_count
                                    
                                }
                        } else {
                            
                        }
                    }
                } catch let error { print(error) }
            }
            task.resume()

        }
    }
    
    func putLike() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/likes.json")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let body = LikeRequest(activity_id: activity_id)
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
    
    
    func putNotLike() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/likes/\(activity_id).json")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let body = LikeRequest(activity_id: activity_id)
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
}
    
