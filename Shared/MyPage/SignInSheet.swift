//
//  SignInSheet.swift
//  saucialApp
//
//  Created by kawayuta on 5/5/21.
//

import Foundation
import SwiftUI
import Combine
import UIKit

struct SignInSheet: View {
    @StateObject var viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    var emailTextFeild: some View {
        VStack(alignment: .leading) {
            Text("メールアドレス").font(.headline, weight: .bold)
            TextField("", text: $viewModel.email).padding()
                .frame(maxWidth: .infinity, maxHeight: .none)
                .background(Color(hex: "EEE"))
                .foregroundColor(.black)
                .accentColor(Color("FFF"))
                .cornerRadius(10)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            if !viewModel.emailRegisterValidate { Text(viewModel.emailRegisterValidateMessage).font(.subheadline).foregroundColor(.red) }
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
    }
    
    var passwordTextFeild: some View {
        VStack(alignment: .leading) {
            Text("パスワード").font(.headline, weight: .bold)
            TextField("６〜15文字以内", text: $viewModel.password).padding()
                .frame(maxWidth: .infinity, maxHeight: .none)
                .background(Color(hex: "EEE"))
                .foregroundColor(.black)
                .accentColor(Color("FFF"))
                .cornerRadius(10)
                .textContentType(.newPassword)
                .keyboardType(.alphabet)
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
    }
    
    var updateButton: some View {
        Button("ログイン") {
            viewModel.authSignIn(completion: { signInCompletion in })
        }
        .font(.title2, weight: .bold)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .none)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 25, trailing: 15))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                emailTextFeild.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                passwordTextFeild
                updateButton
            }
            .padding(EdgeInsets(top: 80, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("別のアカウントでログイン").font(.largeTitle, weight: .bold).frame(height: 40)
                    .background(.white)
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
            }
        }.ignoresSafeArea()
    }
}

