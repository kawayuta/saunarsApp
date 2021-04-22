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
    
}

extension AuthViewModel {
    enum Mode {
        case login
        case signup
    }
}

//    let uid = UUID()
//    private let auth: Auth
//
//    init(auth: Auth) {
//        self.auth = auth
//    }
//
//    var id: String {
//        return self.auth.name
//    }
//
//    var provider: String {
//        return self.auth.name
//    }
//
//    var uid: String {
//        return self.auth.name
//    }
//
//    var allow_password_change: Bool {
//        return self.auth.name
//    }
//
//    var name: String {
//        return self.auth.name
//    }
//
//    var username: String {
//        return self.auth.name
//    }
//
//    var image: URL? {
//        guard let urlString = article.image else { return nil }
//        return URL(string: urlString)
//    }
//    var email: String {
//        return self.auth.name
//    }
//
//
//    var created_at: String {
//        return self.auth.name
//    }
//
//    var description: String {
//        return self.auth.articleDescription ?? ""
//    }
//
//    var timeSincePublishedString: String {
//        let components = calendar.dateComponents([.hour, .minute], from: article.publishedDate, to: now)
//
//        if let hours = components.hour, hours > 0 {
//            return "\(hours)h ago"
//        } else if let mintutes = components.minute, mintutes > 0 {
//            return "\(mintutes)m ago"
//        } else {
//            return "now"
//        }
//    }

    
