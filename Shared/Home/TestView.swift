//
//  Test.swift
//  saucialApp
//
//  Created by kawayuta on 3/13/21.
//

import SwiftUI
import PartialSheet

struct TestView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    
    init() {
        viewModel = .init(mode: .login)
        if UserDefaults.standard.string(forKey: "email") != nil {
            viewModel.email = UserDefaults.standard.string(forKey: "email")!
        }
        if UserDefaults.standard.string(forKey: "password") != nil {
            viewModel.password = UserDefaults.standard.string(forKey: "password")!
        }
    }
    
    var body: some View {
        NavigationView() {
            VStack {
                Text(String(viewModel.RequestStateFlag))
                
                NavigationLink(destination:
                                WentSaunaView(viewModel: .init(mode: .saunas)).environmentObject(PartialSheetManager()), isActive: $viewModel.RequestStateFlag) {
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .animation(.none)
                
            }
        }
//        .navigationBarTitle("")
//        .navigationBarHidden(true)
//        .onAppear {
//            UINavigationBar.setAnimationsEnabled(false)
////            self.viewModel.authSignIn()
//        }
    }
    
    func autoSignIn() {
//        self.viewModel.authSignIn()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
