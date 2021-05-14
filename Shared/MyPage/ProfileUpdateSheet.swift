//
//  ProfileUpdateSheet.swift
//  saucialApp
//
//  Created by kawayuta on 5/5/21.
//

import SwiftUI

struct ProfileUpdateSheet: View {
    
    @StateObject var viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    
    var nameTextFeild: some View {
        VStack(alignment: .leading) {
            Text("名前").font(.headline, weight: .bold)
            TextField("10文字以内", text: $viewModel.name)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .none)
                .background(Color(hex: "EEE"))
                .foregroundColor(.black)
                .accentColor(Color("FFF"))
                .cornerRadius(10)
                .textContentType(.nickname)
                .keyboardType(.default)
            if !viewModel.nameRegisterValidate { Text(viewModel.nameRegisterValidateMessage).font(.subheadline).foregroundColor(.red) }
            
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
    }
    
    
    var updateButton: some View {
        Button("完了") {
            viewModel.updateValidate()
            viewModel.updateUser()
//            print($viewModel.username)
//            print($viewModel.email)
//            print($viewModel.password)
//            print($viewModel.confilmPassword)
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
                ProfileImageView(viewModel: viewModel).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                if !viewModel.avatarRegisterValidate { Text(viewModel.avatarRegisterValidateMessage).font(.subheadline).foregroundColor(.red) }
                nameTextFeild
                updateButton
            }
            .padding(EdgeInsets(top: 80, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("プロフィール編集").font(.largeTitle, weight: .bold).frame(height: 40)
                    .background(.white)
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
            }
        }.ignoresSafeArea()
    }
}
