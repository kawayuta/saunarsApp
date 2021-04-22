//
//  SignUpView.swift
//  saucialApp
//
//  Created by kawayuta on 3/11/21.
//

import SwiftUI
import UIKit

struct SignUpView: View {
    var body: some View {
        SignUpTitleView()
    }
}

struct SignUpTitleView: View {
    var body: some View {
        VStack() {
            Spacer()
            SignUpFieldView()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .none)
        .background(Color(hex: "DDD"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SignUpFieldView: View {
    var body: some View {
        VStack() {
            Text("新しいアカウント")
                .font(.title2).bold().frame(maxWidth: .infinity, maxHeight: .none, alignment: .leading)
                .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
            UsernameField()
            EmailField()
            NewPasswordField()
            ConfilmPasswordField()
            RegisterButton()
        }
        .background(Color(hex: "FFF")).cornerRadius(25)
    }
}

struct UsernameField: View {
    @State private var username = ""

    var body: some View {
        
        TextField("ユーザーネーム", text: $username)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 15))
    }
}

struct EmailField: View {
    @State private var emailField = ""

    var body: some View {
        TextField("メールアドレス", text: $emailField).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
    }
}

struct NewPasswordField: View {
    @State private var newPassword = ""

    var body: some View {
        TextField("新しいパスワード", text: $newPassword).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
    }
}

struct ConfilmPasswordField: View {
    @State private var confilmPassword = ""

    var body: some View {
        TextField("新しいパスワード（確認）", text: $confilmPassword).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
}


struct RegisterButton: View {
    @State private var username = ""

    var body: some View {
        Button("次へ") {
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .none)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 25, trailing: 15))
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
