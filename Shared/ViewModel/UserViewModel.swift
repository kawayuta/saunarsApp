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
    
    @Published var activities_month_sauna: [Double] = []
    @Published var activities_month_mizu: [Double] = []
    @Published var activities_month_mizu_adjust: [Double] = []
    @Published var activities_month_rate: Int = 0
    
    let userDefaults = UserDefaults.standard
    var current_user_id: Int = 0
    @Published var tapSaunaId: Int?
    @Published var profileRegisterVisible: Bool = false
    @Published var profileEditVisible: Bool = false
    @Published var profileOtherSignInVisible: Bool = false
    @Published var whichSheet: SheetSettings = SheetSettings.none
    
    @Published var is_member = false
    
    
    @Published var avatar: UIImage?
    @Published var name = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confilmPassword = ""
    @Published var currentPassword = ""
    
    @Published var avatarRegisterValidate = true
    @Published var nameRegisterValidate = true
    @Published var usernameRegisterValidate = true
    @Published var emailRegisterValidate = true
    @Published var passwordRegisterValidate = true
    
    @Published var avatarRegisterValidateMessage = ""
    @Published var nameRegisterValidateMessage = ""
    @Published var usernameRegisterValidateMessage = ""
    @Published var emailRegisterValidateMessage = ""
    @Published var passwordRegisterValidateMessage = ""
    
    enum SheetSettings {
        case none
        case otherSignIn
        case accountSetting
    }
    
    
    func createTotal() {
            activities_month_sauna.removeAll()
            activities_month_mizu.removeAll()
            activities_month_mizu_adjust.removeAll()
            if let user = user {
                user.activities_month_saunas_rooms.map {
                    if $0.mizu_temperature != nil && $0.sauna_temperature != nil {
                        
                        let sauna_temp = Double($0.sauna_temperature!)
                        let mizu_temp = Double($0.mizu_temperature!)
                        activities_month_sauna.insert(sauna_temp, at: 0)
                        activities_month_mizu.insert(mizu_temp, at: 0)
                        activities_month_mizu_adjust.insert(mizu_temp * 4, at: 0)
                        print(activities_month_sauna)
                        print(activities_month_mizu)
                    }
                }
            }
            
            if activities_month_sauna.count > 1 {
                let last = activities_month_sauna.last! - activities_month_mizu.last!
                let prev = activities_month_sauna[activities_month_sauna.count - 2] - activities_month_mizu[activities_month_mizu.count - 2]
                activities_month_rate = Int(last) - Int(prev)
                print(Int(last))
                print(Int(prev))
            } else {
                activities_month_rate = 0
            }
        }
        
    
    func updateValidate() {
        
        if name != "" && name.count > 0 && name.count <= 10 {
            nameRegisterValidate = true
            nameRegisterValidateMessage = ""
        } else {
            nameRegisterValidate = false
            nameRegisterValidateMessage = "1〜10文字以内の名前を入力してください"
        }
    }
    
    
    func registerValidate() {
        
        if username != "" && username.count > 0 && username.count <= 10 && username.isAlphanumeric() {
            usernameRegisterValidate = true
            usernameRegisterValidateMessage = ""
        } else if username.isAlphanumeric() == false {
            usernameRegisterValidate = false
            usernameRegisterValidateMessage = "英数字で入力してください"
            
        } else {
            usernameRegisterValidate = false
            usernameRegisterValidateMessage = "英数字で1〜10文字以内の名前を入力してください"
        }
        
        if email != "" && email.contains("@") && email.isMailAlphanumeric() {
            emailRegisterValidate = true
            emailRegisterValidateMessage = ""
        } else if email.isMailAlphanumeric() == false {
            emailRegisterValidate = false
            emailRegisterValidateMessage = "正しいメールアドレスを入力してください"
        } else {
            emailRegisterValidate = false
            emailRegisterValidateMessage = "一度も登録していない正しいメールアドレスを入力してください"
        }
        
        if password != "" && password.count > 5 && password.count <= 15 && password.isAlphanumeric() {
            passwordRegisterValidate = true
            passwordRegisterValidateMessage = ""
            if password != confilmPassword {
                passwordRegisterValidate = false
                passwordRegisterValidateMessage = "パスワードが一致していません"
            } else {
                passwordRegisterValidate = true
                passwordRegisterValidateMessage = ""
            }
        } else if password.isAlphanumeric() == false {
            passwordRegisterValidate = false
            passwordRegisterValidateMessage = "英数字で入力してください"
            
        } else {
            passwordRegisterValidate = false
            passwordRegisterValidateMessage = "6〜15文字以内のパスワードを入力してください"
        }
    }
    
    
    func updateUser() {
        
        current_user_id = userDefaults.integer(forKey: "current_id")
        
        guard avatarRegisterValidate && nameRegisterValidate else {
            return
        }
//        currentPassword = userDefaults.string(forKey: "password")!
        var img: String = ""
        let compressionQuality: CGFloat = 0.8
        if let avatar = avatar {
            let imageData = avatar.jpegData(compressionQuality: compressionQuality)
            if let imgData = imageData {
                img = imgData.base64EncodedString()
            }
        }

        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/users/\(current_user_id).json")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let body = UserUpdateRequest(avatar: img, name: name, username: username)
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
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("register success")
                            DispatchQueue.main.async {
                                self.profileEditVisible = false
                            }
                        } else {
                            print("register error")
                        }
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
    
    func updatePassWordUser(completion: @escaping(Bool) -> Void) {
        
        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/api/auth/password")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let body = UserUpdatePassWordRequest(password: password, password_confirmation: confilmPassword)
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
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("password change success")
                            completion(true)
                        } else {
                            completion(false)
                            print("password change error")
                        }
                    }
                    
                } catch let error {
                    completion(false)
                    print(error)
                }
            }
            task.resume()
            
        } catch {
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    func authSignIn(completion: @escaping(Bool) -> Void) {
        let url = URL(string: "\(API.init().host)/api/auth/sign_in")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = AuthRegisterRequest(username: username, email: email, password: password, password_confirmation: confilmPassword)
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = self.userDefaults.string(forKey: "accessToken")
        headers["token-type"] = self.userDefaults.string(forKey: "tokenType")
        headers["client"] = self.userDefaults.string(forKey: "client")
        headers["expiry"] = self.userDefaults.string(forKey: "expiry")
        headers["uid"] = self.userDefaults.string(forKey: "uid")
        request.allHTTPHeaderFields = headers
        
//        print(headers["access-token"])
//        print(headers["token-type"])
//        print(headers["client"])
//        print(headers["expiry"])
//        print(headers["uid"])
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
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
                            DispatchQueue.main.async {
                                self.profileOtherSignInVisible = false
                                exit(0)
                            }
                            completion(true)
                        } else {
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
    
    func registerUser() {
        currentPassword = userDefaults.string(forKey: "password")!
        
        guard usernameRegisterValidate && emailRegisterValidate && passwordRegisterValidate else {
            return 
        }
        var _: String = ""
//        let compressionQuality: CGFloat = 0.8
//        if let avatar = avatar {
//            let imageData = avatar.jpegData(compressionQuality: compressionQuality)
//            if let imgData = imageData {
//                img = imgData.base64EncodedString()
//            }
//        }

        let userDefaults = UserDefaults.standard
        let url = URL(string: "\(API.init().host)/users/\(current_user_id).json")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let body = UserRegisterRequest(username: username, email: email, password: password, password_confirmation: confilmPassword, current_password: currentPassword)
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
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            
                            self.userDefaults.set(self.email, forKey: "email")
                            self.userDefaults.set(self.password, forKey: "password")
                            print("register success")
                            DispatchQueue.main.async {
                                self.profileRegisterVisible = false
                            }
                            
                            authSignIn(completion: { signInCompletion in })
                        } else {
                            
                            
                             usernameRegisterValidate = false
                             usernameRegisterValidateMessage = "既に他の人に使われている可能性があります"
                            
                            print("register error")
                        }
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
    
    
    func fetchUser() {
        current_user_id = userDefaults.integer(forKey: "current_id")
        if userDefaults.string(forKey: "password") != nil {
            currentPassword = userDefaults.string(forKey: "password")!
        }
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
                            
                                DispatchQueue.main.async {
                                    user = json
                                    createTotal()
                                    if let name = json.name { self.name = name }
                                    
                                    if !json.email.contains("saunavi.app.com") {
                                        email = json.email
                                        username = json.username
                                        password = currentPassword
                                        confilmPassword = currentPassword
                                    } else {
                                        
                                        if let udid = UIDevice.current.identifierForVendor?.uuidString {
                                            username = String(udid.split(separator: "-")[0])
                                        }
                                        if json.username != "" {
                                            username = String(json.username.split(separator: "-")[0])
                                            password = ""
                                            confilmPassword = ""
                                        }
                                    }
                                    
                                    if !email.contains("saunavi.app.com") {
                                        is_member = true
                                    } else {
                                        is_member = false
                                    }
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

    
    
    func deleteUserActivity(activity_id: Int) {
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
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            print("activity delete success")
                        } else {
                            print("activity delete error")
                        }
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

