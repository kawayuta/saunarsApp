//
//  MyPageView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/22/21.
//

import SwiftUI
import Neumorphic
import SwiftUIPager

struct MyPageView: View {
    
    @StateObject var viewModel = UserViewModel()
    @State var saunaInfoVisible: Bool = false
    let mainColor = Color.Neumorphic.main
    @State private var selectedTab: Int = 0
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $selectedTab) {
                Text("サ活記録").tag(0)
                Text("行きたい！").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        
            Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(height: 1)
                
        
            Pager(page: Page.withIndex(selectedTab),
                  data: 0..<2,
                  id: \.self,
                  content: { index in
                    wentListView.tag(1)
                    activityListView.tag(0)
            })
            .onPageChanged({ (newIndex) in
                selectedTab = newIndex
            }).ignoresSafeArea()
        }.navigationBarTitle("マイページ")
        .onAppear() {
            viewModel.fetchUser()
        }
    }
    
    var wentListView: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
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
                        }
                        .onTapGesture {
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
        }
    }
    
    var activityListView: some View {
        
        VStack(alignment: .leading) {
            if let user = viewModel.user {
                if let activities_saunas = user.activities_saunas {
                    
                    List {
                        ForEach(user.activities.indices, id: \.self) { index in
                            VStack {
                                HStack(alignment: .top) {
                                    URLImageView("\(API.init().imageUrl)\(user.activities_saunas[index].image.url)")
                                        .frame(width: 80, height: 80)
                                        .aspectRatio(contentMode: .fill)
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading) {
                                            Text(user.activities_saunas[index].name_ja)
                                                .font(.title3, weight: .bold)
                                                .frame(alignment: .top)
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                        HStack(alignment: .top, spacing: 0) {
                                            VStack(alignment: .trailing) {
                                                Text("サウナ: ")
                                                    .font(.subheadline, weight: .bold)
                                                    .foregroundColor(.white).padding(1)
                                                Text("水風呂: ")
                                                    .font(.subheadline, weight: .bold)
                                                    .foregroundColor(.white).padding(1)
                                                Text("休憩: ")
                                                    .font(.subheadline, weight: .bold)
                                                    .foregroundColor(.white).padding(1)
                                            }
                                            .frame(width: 44)
                                            
                                            VStack(alignment: .trailing) {
                                                Text("\(user.activities[index].sauna_time)分 - \(user.activities[index].sauna_count)回")
                                                    .font(.subheadline, weight: .bold)
                                                    .foregroundColor(.white).padding(1)
                                                Text("\(user.activities[index].mizuburo_time)分 - \(user.activities[index].mizuburo_count)回")
                                                    .font(.subheadline, weight: .bold)
                                                    .foregroundColor(.white).padding(1)
                                                Text("\(user.activities[index].rest_time)分 - \(user.activities[index].rest_count)回")
                                                    .font(.subheadline, weight: .bold)
                                                    .foregroundColor(.white).padding(1)
                                            }
                                        }
                                    }.frame(height: 80)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
                                }
                                
                            }.cornerRadius(15)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue).softOuterShadow())
                            
                        }.onDelete(perform: self.deleteRow)
                    }
                }
            }
        }
        
    }
    
    func deleteRow(offsets: IndexSet) {
        if let index: Int = offsets.first {
            if let user = viewModel.user {
                let activity_id = user.activities[index].id
                viewModel.deleteUserActivity(activity_id: activity_id)
                viewModel.fetchUser()
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
