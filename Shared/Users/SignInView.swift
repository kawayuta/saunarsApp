//
//  SignInView.swift
//  saucialApp
//
//  Created by kawayuta on 3/11/21.
//

import SwiftUI
import UIKit
import PartialSheet

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
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
        TextField("パスワード", text: $viewModel.password).padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("FFF"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
    }
    
    var loginButton: some View {
        Button("ログイン") {
            print($viewModel.email)
            print($viewModel.password)
            
//            viewModel.authSignIn()
            
            print(viewModel.RequestStateFlag)
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
                Text(String(viewModel.RequestStateFlag))
                Text(viewModel.title)
                    .font(.title2).bold().frame(maxWidth: .infinity, maxHeight: .none, alignment: .leading)
                    .padding(EdgeInsets(top: 25, leading: 15, bottom: 0, trailing: 15))
                
                emailTextFeild
                passwordTextFeild
                loginButton
                NavigationLink(destination: TestView(), isActive: $viewModel.RequestStateFlag) {}
            }
            .background(Color(hex: "FFF")).cornerRadius(25)
        }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: .init(mode: .login))
    }
}
