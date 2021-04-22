//
//  SignUpView.swift
//  saucialApp
//
//  Created by kawayuta on 3/11/21.
//

import SwiftUI
import UIKit
import PartialSheet

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var usernameTextFeild: some View {
        TextField("ユーザーネーム", text: $viewModel.username)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 15))
    }
    
    var emailTextFeild: some View {
        TextField("メールアドレス", text: $viewModel.email).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
    }
    
    var passwordTextFeild: some View {
        TextField("新しいパスワード", text: $viewModel.password).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
    }
    
    var confilmPasswordTextFeild: some View {
        TextField("新しいパスワード（確認）", text: $viewModel.confilmPassword).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    var registerButton: some View {
        Button("次へ") {
            print($viewModel.username)
            print($viewModel.email)
            print($viewModel.password)
            print($viewModel.confilmPassword)
//            viewModel.authSignUp()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .none)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 25, trailing: 15))
    }
    
    
    
    var body: some View {
        VStack() {
            Text(viewModel.title)
                .font(.title2).bold().frame(maxWidth: .infinity, maxHeight: .none, alignment: .leading)
                .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
            
            usernameTextFeild
            emailTextFeild
            passwordTextFeild
            confilmPasswordTextFeild
            registerButton
            NavigationLink(destination: TestView(), isActive: $viewModel.RequestStateFlag) {}
        }
        .background(Color(hex: "FFF")).cornerRadius(25)
    }
}
//
//struct SignUpTitleView: View {
//    var body: some View {
//        VStack() {
//            Spacer()
////            SignUpFieldView(viewModel: <#AuthViewModel#>)
//        }
//        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .none)
//        .background(Color(hex: "DDD"))
//        .edgesIgnoringSafeArea(.all)
//    }
//}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: .init(mode: .signup))
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
