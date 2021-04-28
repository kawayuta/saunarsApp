//
//  SaunaViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 3/27/21.
//

import Foundation
import SwiftUI
import FeedKit

final class SaunaViewModel: ObservableObject {
    @Published var sauna: Sauna?
    @Published var sauna_id: String
    @Published var rssFeed: RSSFeed?
    @Published var atomFeed: AtomFeed?
    @Published var jsonFeed: JSONFeed?
    
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
                            DispatchQueue.main.async { [self] in
                                self.sauna = json
                                self.fetchRSSFeed()
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
    
    func fetchRSSFeed() {
        if let sauna = sauna {
            if let feed = sauna.feed {
                let url = URL(string: feed)
                let parser = FeedParser(URL: url!)
                parser.parseAsync { [weak self] (result) in
                    guard let self = self else { return }
                        switch result {
                        case .success(let feed):
                            DispatchQueue.main.async {
                                self.rssFeed = feed.rssFeed
                                self.atomFeed = feed.atomFeed
                                self.jsonFeed = feed.jsonFeed
                            }
                            
                            // switch feed {
                            // case let .rss(feed): break
                            // case let .atom(feed): break
                            // case let .json(feed): break
                            // }
                            
                        case .failure(let error):
                            print(error)
                    }
                }
                
            }
        }
    }
}
