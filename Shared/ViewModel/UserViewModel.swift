//
//  UserViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 4/22/21.
//

import Foundation
import SwiftUI


final class UserViewModel: ObservableObject {
    @Published var user: User?
    let userDefaults = UserDefaults.standard
    let current_user_id: Int
    @Published var tapSaunaId: Int?
    
    init() {
        current_user_id = userDefaults.integer(forKey: "current_id")
    }
    
    
    func fetchUser() {
        let url = URL(string: "\(API.init().host)/users/\(String(current_user_id)).json")!
        
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
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                guard let data = data else { return }
                do {
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(User.self, from: data)
                            user = json
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

