//
//  AuthViewModel.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 3/12/21.
//

import Foundation
import SwiftUI

final class AuthViewModel: ObservableObject {
    
    private let mode: Mode
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confilmPassword = ""
    @Published var RequestStateFlag = false
    
    private let userDefaults = UserDefaults.standard
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Login"
        case .signup:
            return "Register"
        case .mypage:
            return "MyPage"
        }
    }
}

extension AuthViewModel {
    enum Mode {
        case login
        case signup
        case mypage
    }
}


extension AuthViewModel {
    
    func autoSignUpIn(completion: @escaping(Bool) -> Void) {
        if let udid = UIDevice.current.identifierForVendor?.uuidString {
            username = ""
            email = "\(udid)@saunavi.app.com"
            password = udid
            confilmPassword = udid
            
            authSignIn(completion: { [self] signInCompletion in
                if signInCompletion {
                    print("ログインしたよ")
                    completion(true)
                } else {
                    print("ログインできないよ")
//                    アカウントを作成してログイン
                    self.authSignUp(completion: { signUpCompletion in
                        if signUpCompletion {
                            print("アカウント作ったよ")
                            if signInCompletion {
                                completion(true)
                                print("アカウント作ってログインしたよ")
                            } else {
                                completion(false)
                                print("アカウント作ったのにログインできないよ")
                            }
                        } else {
                            print("アカウントがあるよ")
                            if signInCompletion {
                                completion(true)
                                print("もともとあったアカウントでログインしたよ")
                            } else {
                                completion(false)
                                print("アカウントあるのにログインできないよ")
                            }
                            
                        }
                    })
                }
            })
            
            
        }
    }
    func authSignUp(completion: @escaping(Bool) -> Void) {
        let url = URL(string: "\(API.init().host)/api/auth")!
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
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        let accessToken = httpResponse.allHeaderFields["access-token"]
                        let tokenType = httpResponse.allHeaderFields["token-type"]
                        let client = httpResponse.allHeaderFields["client"]
                        let expiry = httpResponse.allHeaderFields["expiry"]
                        let uid = httpResponse.allHeaderFields["uid"]
                        
                        self.userDefaults.set(accessToken, forKey: "accessToken")
                        self.userDefaults.set(tokenType, forKey: "tokenType")
                        self.userDefaults.set(client, forKey: "client")
                        self.userDefaults.set(expiry, forKey: "expiry")
                        self.userDefaults.set(uid, forKey: "uid")
                        
                        if httpResponse.statusCode == 200 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                } catch let error {
                    completion(false)
                    print("エラー")
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func authSignIn(completion: @escaping(Bool) -> Void) {
        let url = URL(string: "\(API.init().host)/api/auth/sign_in")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = AuthRegisterRequest(username: username, email: email, password: password, confilm_password: confilmPassword)
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = self.userDefaults.string(forKey: "accessToken")
        headers["token-type"] = self.userDefaults.string(forKey: "tokenType")
        headers["client"] = self.userDefaults.string(forKey: "client")
        headers["expiry"] = self.userDefaults.string(forKey: "expiry")
        headers["uid"] = self.userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            
                            DispatchQueue.main.async { self.RequestStateFlag = true }
                            self.userDefaults.set(self.email, forKey: "email")
                            self.userDefaults.set(self.password, forKey: "password")
//                            self.userDefaults.set(self.RequestStateFlag, forKey: "isLogin")
                            
                            let accessToken = httpResponse.allHeaderFields["access-token"]
                            let tokenType = httpResponse.allHeaderFields["token-type"]
                            let client = httpResponse.allHeaderFields["client"]
                            let expiry = httpResponse.allHeaderFields["expiry"]
                            let uid = httpResponse.allHeaderFields["uid"]
                            
                            self.userDefaults.set(accessToken, forKey: "accessToken")
                            self.userDefaults.set(tokenType, forKey: "tokenType")
                            self.userDefaults.set(client, forKey: "client")
                            self.userDefaults.set(expiry, forKey: "expiry")
                            self.userDefaults.set(uid, forKey: "uid")
                            
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(AuthResponse.self, from: data)
                            self.userDefaults.set(json.data.id, forKey: "current_id")
                            completion(true)
                        } else {
                            DispatchQueue.main.async { self.RequestStateFlag = false }
//                            self.userDefaults.set(self.RequestStateFlag, forKey: "isLogin")
                            completion(false)
                        }
                    }
                    
                    
                } catch let error {
                    completion(false)
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

