//
//  SignUpSheet.swift
//  saucialApp
//
//  Created by kawayuta on 5/5/21.
//

import SwiftUI

struct SignUpSheet: View {
    
    @StateObject var viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    
    var usernameTextFeild: some View {
        VStack(alignment: .leading) {
            Text("ユーザー名").font(.headline, weight: .bold)
            TextField("英数字 10文字以内", text: $viewModel.username)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .none)
                .background(Color(hex: "EEE"))
                .foregroundColor(.black)
                .accentColor(Color("FFF"))
                .cornerRadius(10)
                .textContentType(.nickname)
                .keyboardType(.alphabet)
            if !viewModel.usernameRegisterValidate { Text(viewModel.usernameRegisterValidateMessage).font(.subheadline).foregroundColor(.red) }
            
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
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
            Text("新しいパスワード").font(.headline, weight: .bold)
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
    
    var confilmPasswordTextFeild: some View {
        
            VStack(alignment: .leading) {
                Text("新しいパスワード（確認）").font(.headline, weight: .bold)
                TextField("新しいパスワード（確認）", text: $viewModel.confilmPassword).padding()
                    .frame(maxWidth: .infinity, maxHeight: .none)
                    .background(Color(hex: "EEE"))
                    .foregroundColor(.black)
                    .accentColor(Color("FFF"))
                    .cornerRadius(10)
                    .textContentType(.newPassword)
                    .keyboardType(.alphabet)
                if !viewModel.passwordRegisterValidate { Text(viewModel.passwordRegisterValidateMessage).font(.subheadline).foregroundColor(.red) }
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
    }
    
    var updateButton: some View {
        Button("完了") {
            viewModel.registerValidate()
            // passwordから先に更新
            viewModel.updatePassWordUser(completion: { passwordChangeCompletion in
                if passwordChangeCompletion {
                    viewModel.registerUser()
                }
            })
            print($viewModel.username)
            print($viewModel.email)
            print($viewModel.password)
            print($viewModel.confilmPassword)
//            viewModel.authSignUp()
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
//                ProfileImageView(viewModel: viewModel).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
//                if !viewModel.avatarRegisterValidate { Text(viewModel.avatarRegisterValidateMessage).font(.subheadline).foregroundColor(.red) }
//                nameTextFeild
                usernameTextFeild
                emailTextFeild
                passwordTextFeild
                confilmPasswordTextFeild
                updateButton
            }
            .padding(EdgeInsets(top: 80, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("アカウント設定").font(.largeTitle, weight: .bold).frame(height: 40)
                    .background(.white)
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
            }
        }.ignoresSafeArea()
    }
}
