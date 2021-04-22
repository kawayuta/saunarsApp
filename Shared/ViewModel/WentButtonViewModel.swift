//
//  WentViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//

import Foundation
import SwiftUI

final class WentButtonViewModel: ObservableObject {
    
    private let mode: Mode
    @Published var state: Bool = false
    @Published var sauna_id: String
    
    init(mode: Mode, sauna_id: String) {
        self.mode = mode
        self.sauna_id = sauna_id
    }
}

extension WentButtonViewModel {
    enum Mode {
        case like
        case went
    }
}

extension WentButtonViewModel {
    
    func fetchWent() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/wents/\(sauna_id).json")
        var request = URLRequest(url: url!)
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = userDefaults.string(forKey: "accessToken")
        headers["token-type"] = userDefaults.string(forKey: "tokenType")
        headers["client"] = userDefaults.string(forKey: "client")
        headers["expiry"] = userDefaults.string(forKey: "expiry")
        headers["uid"] = userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
//        print(userDefaults.string(forKey: "accessToken"))
//        print(userDefaults.string(forKey: "tokenType"))
//        print(userDefaults.string(forKey: "client"))
//        print(userDefaults.string(forKey: "expiry"))
//        print(userDefaults.string(forKey: "uid"))
        
        do {
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                guard let data = data else { return }
                do {

                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(CheckWent.self, from: data)
                            if let is_went = json.is_went {
                                DispatchQueue.main.async { state = is_went }
                            }
                        } else {
                            
                        }
                    }
                } catch let error { print(error) }
            }
            task.resume()

        }
    }
    
    func putWent() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/wents.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print(sauna_id)
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
    
    
    func putNotWent() {
        print(sauna_id)
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
}
    
