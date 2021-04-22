//
//  NetworkService.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 3/12/21.
//

import Foundation
import UIKit

typealias ErrorCallback = (Error) -> Void
typealias AuthCallback = ([Auth]) -> Void

private enum RequestError: String, Error {
    case noData = "No response from server please try again."
    case decodeFailed = "The server response is missing data. Please try again."
    case badUrl = "Server url is invalid."

    var error: Error {
        return NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey : self.rawValue]) as Error
    }
}

final class NetworkService {
    private let path = Bundle.main.path(forResource: "Keys", ofType: "plist")!

    private var apiKey: String {
        return NSDictionary(contentsOfFile: path)!.value(forKey: "ApiKey") as! String
    }

    private let baseURL: String =  "http://localhost:3000/api"

    func sendAuthRegist(onSuccess: AuthCallback?, onError: ErrorCallback?) {
        guard let url = URL(string: "\(baseURL)\("/auth")") else {
            onError?(RequestError.badUrl.error)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in

        }.resume()
    }
}
