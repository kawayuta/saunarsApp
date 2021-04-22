//
//  AuthViewModel.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 3/12/21.
//

import Foundation

final class AuthViewModel: ObservableObject {
    
    private let mode: Mode
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confilmPassword = ""
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    var title: String {
        switch mode {
        case .login:
            return "SIGNin"
        case .signup:
            return "SIgn UP"
        }
    }
    
    func authSignUp() {
        let url = URL(string: "http://localhost:3000/api/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = AuthRegisterRequest(username: username, email: email, password: password, confilm_password: confilmPassword)
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    print(object)
                    if let httpResponse = response as? HTTPURLResponse {
                        var accessToken = httpResponse.allHeaderFields["access-token"]!
                        var uid = httpResponse.allHeaderFields["uid"]!
                        var client = httpResponse.allHeaderFields["client"]!
                        
                        UserDefaults.standard.string(forKey: <#T##String#>)
                        print(httpResponse.allHeaderFields)
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

extension AuthViewModel {
    enum Mode {
        case login
        case signup
    }
}
