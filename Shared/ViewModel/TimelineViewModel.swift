//
//  TimelineViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 5/6/21.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import URLQueryItemsCoder
import MapKit

final class TimelineViewModel: ObservableObject {
    @Published var activities: [TimelineActivity] = []
    
    func deleteTimelineActivity(activity_id: Int, completion: @escaping(Bool) -> Void) {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/activities/\(activity_id).json")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let body = deleteActivityRequest(activity_id: activity_id)
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
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard data != nil else { completion(false); return }
                completion(true)
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func fetchTimeline() {
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/activities.json")!
        
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
                            let json = try decoder.decode([TimelineActivity].self, from: data)
                            
                                DispatchQueue.main.async {
                                    activities = json
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
