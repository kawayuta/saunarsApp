//
//  MyPageView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/22/21.
//

import SwiftUI
import Neumorphic
import SwiftUIPager
import SwiftUIX
import PartialSheet

struct MyPageView: View {
    
    @EnvironmentObject var viewModel:UserViewModel
    @State var saunaInfoVisible: Bool = false
    let mainColor = Color.Neumorphic.main
    @State private var selectedTab: Int = 0
    @State var settingVisible: Bool = false
    
    var sheets: some View {
        Group {
            EmptyView()
                .sheet(isPresented: $viewModel.profileOtherSignInVisible) {
                    VStack(alignment: .center) {
                        SignInSheet(viewModel: viewModel)
                        Spacer()
                    }.onDisappear() {
                        viewModel.fetchUser()
                    }
                }
            EmptyView()
                .sheet(isPresented: $viewModel.profileRegisterVisible) {
                    VStack(alignment: .center) {
                        SignUpSheet(viewModel: viewModel)
                        Spacer()
                    }.onDisappear() {
                        viewModel.fetchUser()
                    }
                }
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let user = viewModel.user {
                profileView
                profileMemberEditButton
    //            sheets
                Picker("", selection: $selectedTab) {
//                    Text("サ活記録").tag(0)
                    Text("サ活記録").tag(0)
                    Text("イキタイ！").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))

                Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(height: 1)


                Pager(page: Page.withIndex(selectedTab),
                      data: 0..<2,
                      id: \.self,
                      content: { index in
//                        ActivityCalendarView(activities_month: user.activities_month)
//                            .tag(0)
                        wentListView.tag(0)
                        activityListView.tag(1)
                })
                .onPageChanged({ (newIndex) in
                    selectedTab = newIndex
                }).ignoresSafeArea()
                
            }
        }
        .navigationBarItems(trailing: settingsButton)
    }
    
    
    
    var settingsButton: some View {
        
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            settingVisible = true
        }, label: {
            Image(systemName: "gearshape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16)
                .foregroundColor(Color(hex: "44556b"))
        })
        .sheet(isPresented: $settingVisible) {
            VStack(alignment: .center) {
                Text("設定").font(.largeTitle, weight: .bold).frame(height: 40)
                    .background(.white)
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                profileNotMemberEditButton
                otherProfileLoginButton
                Spacer()
            }
            .onDisappear() {
                viewModel.fetchUser()
            }
        }
        .frame(width: 40, height: 40)
    }
    
    var profileNotMemberEditButton: some View {
        VStack(alignment: .leading) {
            Button(action: {
                viewModel.profileRegisterVisible = true
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }, label: {
                Text("アカウント設定")
                    .font(.title3)
            })
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(EdgeInsets(top: 20, leading: 15, bottom: 25, trailing: 15))
            .sheet(isPresented: $viewModel.profileRegisterVisible) {
                VStack(alignment: .center) {
                    SignUpSheet(viewModel: viewModel)
                    Spacer()
                }.onDisappear() {
                    viewModel.fetchUser()
                }
            }
        }
    }
    
    var profileMemberEditButton: some View {
        VStack(alignment: .leading) {
            Button(action: {
                viewModel.profileEditVisible = true
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }, label: {
                Text("プロフィール編集")
                    .font(.title3)
            })
            .frame(maxWidth: 150, maxHeight: 50, alignment: .center)
            .padding(EdgeInsets(top:0, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(.blue)
            .sheet(isPresented: $viewModel.profileEditVisible) {
                VStack(alignment: .center) {
                    ProfileUpdateSheet(viewModel: viewModel)
                    Spacer()
                }.onDisappear() {
                    viewModel.fetchUser()
                }
            }
        }
    }
    
    var otherProfileLoginButton: some View {
        VStack(alignment: .leading) {
            Button(action: {
                viewModel.profileOtherSignInVisible = true
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }, label: {
                Text("別のアカウントでログイン")
                    .font(.title3)
            })
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .none)
            .background(Color(hex: "ddd"))
            .foregroundColor(Color(hex: "000"))
            .cornerRadius(15)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            .sheet(isPresented: $viewModel.profileOtherSignInVisible) {
                VStack(alignment: .center) {
                    SignInSheet(viewModel: viewModel)
                    Spacer()
                }.onDisappear() {
                    viewModel.fetchUser()
                }
            }
        }
    }
    
    
    var profileView: some View {
        VStack(alignment: .center) {
            if let user = viewModel.user {
                VStack(alignment: .center) {
                    if let avatar = user.avatar {
                        if let image_url = avatar.url {
                            URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .border(Color.white, width: 8, cornerRadius: 28)
                                .cornerRadius(28)
                        } else {
                            Image(uiImage: Bundle.main.icon ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .border(Color.white, width: 8, cornerRadius: 28)
                                .cornerRadius(28).grayscale(1)
                        }
                    }
                    if let name = user.name {
                        Text("\(name)").font(.title3, weight: .bold)
                    } else {
                        Text("名無しサウナー") .font(.title3, weight: .bold)
                    }
                    
                }.padding(15)
            }
        }
    }
    
    var wentListView: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 5) {
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
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
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
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(user.activities.indices, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    
                                    activityHeader(user: user)
                                    activityBodyView(body: user.activities[index].body)
                                    if let images = user.activities[index].images {
                                        activityImageView(images: images)
                                    }
                                    activityFooter(activity: user.activities[index], sauna: activities_saunas[index])
                                    
                                }.cornerRadius(10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                .border(Color(hex: "dedede"), width: 1, cornerRadius: 10)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                                
                            }.onDelete(perform: self.deleteRow)
                        }
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

struct activityHeader: View {
    
    let user: User
    let mainColor = Color.Neumorphic.main
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                if let avatar = user.avatar {
                    Group {
                        if let image_url = avatar.url {
                            URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .border(Color.white, width: 0, cornerRadius: 15)
                                .cornerRadius(15)
                        } else {
                            Image(uiImage: Bundle.main.icon ?? UIImage())
                                .resizable()
                                .frame(width: 30, height: 30)
                                .border(Color.white, width: 0, cornerRadius: 15)
                                .cornerRadius(15)
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
                    
                }
                
                Group {
                    if let name = user.name {
                        Text("\(name)").font(.headline, weight: .bold)
                    } else {
                        Text("名無しサウナー") .font(.headline, weight: .bold)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 15))
            }
            
            
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }.background(mainColor)
    }
}

struct activityFooter: View {
    
    let activity: Activity
    let sauna: ReviewSauna
    let mainColor = Color.Neumorphic.main
    
    init(activity: Activity, sauna: ReviewSauna) {
        self.activity = activity
        self.sauna = sauna
    }
    
    var body: some View {
        HStack(alignment: .top) {
            URLImageViewSta("\(API.init().imageUrl)\(sauna.image.url)")
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fill)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(sauna.name_ja)
                        .font(.headline, weight: .bold)
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
                        Text("\(activity.sauna_time)分 - \(activity.sauna_count)回")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                        Text("\(activity.mizuburo_time)分 - \(activity.mizuburo_count)回")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                        Text("\(activity.rest_time)分 - \(activity.rest_count)回")
                            .font(.subheadline, weight: .bold)
                            .foregroundColor(.white).padding(1)
                    }
                }
            }.frame(height: 80)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
        }
        .background(RoundedRectangle(cornerRadius: 0).fill(Color.blue))
    }
}



struct activityBodyView: View {
    
    let activityBody: String
    let mainColor = Color.Neumorphic.main
    
    init(body: String) {
        activityBody = body
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(activityBody)
                .lineLimit(6)
                .fixedSize(horizontal: false, vertical: true)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 0))
            
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
}

struct activityImageView: View {
    
    let activityImages: [Images]
    
    init(images: [Images]) {
        activityImages = images
    }
    
    var body: some View {
        HStack {
            if activityImages.count == 1 {
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                    ForEach(activityImages.indices, id: \.self) { index in                        URLImageViewSta("\(API.init().imageUrl)\(activityImages[index].url)")
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 230)
                        .clipped()
                        .border(Color.white, width: 0, cornerRadius: 10)
                        .cornerRadius(10)
                    }
                }
                .frame(height: 230)
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            }
            
            
            if activityImages.count == 2 {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 0) {
                    ForEach(activityImages.indices, id: \.self) { index in                        URLImageViewSta("\(API.init().imageUrl)\(activityImages[index].url)")
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 230)
                        .clipped()
                        .border(Color.white, width: 0, cornerRadius: 10)
                        .cornerRadius(10)
                    }
                }
                .frame(height: 230)
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            }
            
            if activityImages.count == 3 {
                VStack {
                    LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                        ForEach([activityImages.first].indices, id: \.self) { index in                        URLImageViewSta("\(API.init().imageUrl)\(activityImages[index].url)")
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                            .border(Color.white, width: 0, cornerRadius: 10)
                            .cornerRadius(10)
                        }
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, spacing: 0) {
                        ForEach(activityImages[1...2].indices, id: \.self) { index in                        URLImageViewSta("\(API.init().imageUrl)\(activityImages[index].url)")
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 80)
                            .clipped()
                            .border(Color.white, width: 0, cornerRadius: 10)
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(height: 230)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }
            
        }
    }

}

