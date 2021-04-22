//
//  MyPageView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/22/21.
//

import SwiftUI

struct MyPageView: View {
    
    @StateObject var viewModel = UserViewModel()
    @State var saunaInfoVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
//                Text((user.username == "" ? "名無しサウナー" : "名無しサウナー"))
//                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                
                
                List {
                    ForEach(user.wents.indices, id: \.self) { index in
                        HStack {
                            URLImageViewSta("\(API.init().imageUrl)\(String(describing: user.wents[index].image.url))")
                                .frame(width:50, height: 50)
                                .aspectRatio(contentMode: .fill)
                            VStack(alignment: .leading) {
                                Text(user.wents[index].name_ja).font(.subheadline, weight: .bold)
                                Text(user.wents[index].address).font(.caption)
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        }.onTapGesture {
                            DispatchQueue.main.async {
                                viewModel.tapSaunaId = user.wents[index].id
                            }
                            if viewModel.tapSaunaId != nil {
                                saunaInfoVisible = true
                            }
                        }
                    }
                }
                .sheet(isPresented: $saunaInfoVisible) {
                    SaunaView(sauna_id: String(viewModel.tapSaunaId!))
                }
            }
        }.navigationBarTitle("行きたいリスト")
        .onAppear() {
            viewModel.fetchUser()
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
