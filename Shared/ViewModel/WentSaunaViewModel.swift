//
//  WentSaunaViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 3/13/21.
//

import Foundation
import URLQueryItemsCoder
import MapKit
import Combine

final class WentSaunaViewModel: ObservableObject {
    
    private let mode: Mode
    @Published var saunas:[Saunas] = []
    @Published var keyword: String = ""
    
    init(mode: Mode) {
        self.mode = mode
    }
}


extension WentSaunaViewModel {
    enum Mode {
        case saunas
    }
}



extension WentSaunaViewModel {
    
    func fetchSaunaList() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/saunas.json?sort=pop")!
        
        var request = URLRequest(url: url)
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
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode([Saunas].self, from: data)
                            DispatchQueue.main.async {
                                self.saunas = json
//                                self.buildMapCoordinate()
                            }
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
            
        }
    }
    
    
    
    
    func searchSaunaList() {
        let userDefaults = UserDefaults.standard
        
        var urlComponents = URLComponents(string: "\(API.init().host)/saunas/search")
        urlComponents?.queryItems = try! URLQueryItemsEncoder().encode(Property(searchKeyword: keyword))
        print(urlComponents?.url?.absoluteString ?? "")
        
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
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode([Saunas].self, from: data)
                            DispatchQueue.main.async { self.saunas = json }
                        } else {
                            print("errordssayona")
                        }
                    }
                    
                    
                } catch let error {
                    print(error)
                }
            }
            task.resume()
            
        }
    }
    
    
    
}
