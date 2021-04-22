//
//  ContentView.swift
//  Shared
//
//  Created by kawayuta on 3/11/21.
//

import SwiftUI

struct LaunchScreenView: View {
    
        var body: some View {
            ButtonWapView()
        }
    
}


struct ButtonWapView: View {
    
   
        var body: some View {
            
            NavigationView {
                VStack {
                    Spacer()
                    SignUpButton()
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
                    SignInButton()
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    
                }.frame(maxWidth: .infinity, maxHeight: .none, alignment: .bottom)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .none, alignment: .bottom)
            
        }
    
}

struct SignUpButton: View {
    @State var newUserText = "はじめる"
    var body: some View {
        NavigationLink(newUserText, destination: SignUpView(viewModel: .init(mode: .signup)))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(30)
    }
}

struct SignInButton: View {
    @State var oldUserText = "既にアカウントをお持ちの方はこちら"
    var body: some View {
        NavigationLink(oldUserText, destination: SignInView(viewModel: .init(mode: .login)))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(30)
            .onAppear {
                UINavigationBar.setAnimationsEnabled(true)
            }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
