//
//  API.swift
//  saucialApp
//
//  Created by kawayuta on 3/28/21.
//

import Foundation

struct API {
    
    let host: HostType = .production
    let imageUrl: imageUrlType = .production
    
    enum HostType: CustomStringConvertible {
        case develop
        case staging
        case production
        
        var description: String {
            switch self {
            case .develop:
                #if targetEnvironment(simulator)
                    return "http://0.0.0.0"
                #else
                    return "http://kawayuta.local"
                #endif
            case .staging:
                return "http://118.27.30.51"
            case .production:
                return "https://o9sec.com"
            }
        }
    }
    
    enum imageUrlType: CustomStringConvertible {
        case develop
        case staging
        case production
        
        var description: String {
            switch self {
            case .develop:
                #if targetEnvironment(simulator)
                    return "http://0.0.0.0"
                #else
                    return "http://kawayuta.local:3000"
                #endif
            case .staging:
                return ""
            case .production:
                return ""
            }
        }
    }
}
