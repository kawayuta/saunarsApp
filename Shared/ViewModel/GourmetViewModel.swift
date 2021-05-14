//
//  GourmetViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 5/10/21.
//

import Foundation
import SwiftUI

final class GourmetViewModel: ObservableObject {
    
    @Published var gourmet: Gourmet?
    @Published var shop: [GourmetShop]?
    
}


extension GourmetViewModel {
    
    func fetchGourmet(lat: String, lng: String) {
        print(lat)
        print(lng)
        let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=8dcb975f5057d3fa&format=json&lat=\(lat)&lng=\(lng)&count=100")
        let request = URLRequest(url: url!)
        do {
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                guard let data = data else { return }
                do {

                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(Gourmet.self, from: data)
                            print(httpResponse)
                            DispatchQueue.main.async {
                                gourmet = json
                                shop = json.results.shop
                                
                            }
                        } else {
                            
                        }
                    }
                } catch let error { print(error) }
            }
            task.resume()

        }
    }
}
