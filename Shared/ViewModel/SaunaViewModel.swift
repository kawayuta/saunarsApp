//
//  SaunaViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 3/27/21.
//

import Foundation
import SwiftUI

final class SaunaViewModel: ObservableObject {
    @Published var sauna: Sauna?
    @Published var sauna_id: String
    
    init(sauna_id: String) {
        self.sauna_id = sauna_id
    }
    
    func fetchSauna() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/saunas/\(String(sauna_id)).json")!
        
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
                            let json = try decoder.decode(Sauna.self, from: data)
                            DispatchQueue.main.async {
                                self.sauna = json
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
}
