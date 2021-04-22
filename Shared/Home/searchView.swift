//
//  searchView.swift
//  saucialApp
//
//  Created by kawayuta on 3/26/21.
//

import SwiftUI
import Neumorphic
import SwiftUIPager

struct searchView: View {
    @StateObject var viewModel: MapViewModel
    @Binding var isPresent: Bool
    
    @State private var selectedTab: Int = 0
    @State var searchOptions = SearchOptions()
    let mainColor = Color.Neumorphic.main
    
    var body: some View {
        VStack(spacing: 0) {
            SearchFieldView
            searchOptionsView
            searchOptionButton
        }.background(mainColor)
        .navigationBarHidden(true)
    }
    
    init(viewModel: MapViewModel, isPresent: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isPresent = isPresent
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    var SearchFieldView: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            TextField("検索", text: $viewModel.keyword, onEditingChanged: { isBegin in
                if isBegin {
                    
                } else {
                    print("未入力中です。")
                }
            }, onCommit: {
            }).padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 15))
                .foregroundColor(.black)
                .accentColor(Color("000"))
                .font(.title3)
            .background(RoundedRectangle(cornerRadius: 30).fill(mainColor)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30),
                                             darkShadow: .black,
                                             lightShadow: .white,
                                             spread: 0.05, radius: 2)
                            )
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22)
                    .foregroundColor(Color(hex: "ccc"))
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                Spacer()
                if viewModel.keyword != "" {
                    Button("✗") { viewModel.keyword = "" }
                        .frame(width: 22)
                        .foregroundColor(Color(hex: "bbb"))
                        .background(Color(hex: "DDD"))
                        .cornerRadius(11)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
                }
                
            }
        }.frame(height: 80)
    }
    
    var searchOptionsView: some View {
        VStack(alignment: .center) {
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            
            VStack(spacing: 0) {
                        Picker("", selection: $selectedTab) {
                            Text("こだわり").tag(0)
                            Text("設備・ルール").tag(1)
                            Text("アメニティ").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                
                    Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(height: 1)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                
                    GeometryReader { proxy in
                        ScrollView {
                            Pager(page: Page.withIndex(selectedTab),
                                  data: 0..<3,
                                  id: \.self,
                                  content: { index in
                                    searchOptionsRecommendView
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                        .tag(0)
                                    searchOptionsRoleView
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                        .tag(1)
                                    searchOptionsAmenityView
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                        .tag(2)
                            })
                            .onPageChanged({ (newIndex) in
                                selectedTab = newIndex
                            })
                            .multiplePagination()
                            .frame(width: proxy.size.width, height: min(proxy.size.height, proxy.size.width))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 365)
//
//                TabView(selection: $selectedTab) {
//                            searchOptionsRecommendView
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                                .tag(0)
//                            searchOptionsRoleView
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                                .tag(1)
//                            searchOptionsAmenityView
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                                .tag(2)
//                }
//                .frame(maxWidth: .infinity, maxHeight: 365)
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
            }
            
        }.frame(alignment: .bottom)
        
    }
    
    
    var searchOptionButton: some View {
        
        VStack(spacing: 0) {
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            
            Button("検索") {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                withAnimation {
                    isPresent = false
                }
                searchOptions.optionValidCheck()
                viewModel.searchSaunaList(writeRegion: true)
            }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 55, maxHeight: 55).font(.title)
            .foregroundColor(Color.white)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow())
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        }
    }
}


extension searchView {
    var searchOptionsRecommendView: some View {
        VStack {
            VStack {
                HStack(alignment: .center) {
                    Text("サウナ").font(.headline).foregroundColor(Color(hex: "44556b")).fontWeight(.bold)
                    Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 5))
                
                HStack {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(0..<searchOptions.saunaTypeTagList.count, id: \.self) { index in
                            let title = searchOptions.saunaTypeTagList[index]
                                Button(title) {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    let impactLig = UIImpactFeedbackGenerator(style: .light)
                                    searchOptions.tagTitle ?? "" == title ? impactMed.impactOccurred() : impactLig.impactOccurred()
                                    searchOptions.tagTitle = UserDefaults.standard.string(forKey: "tagTitle") ?? "" == title ? "" : title
                                    UserDefaults.standard.setValue(UserDefaults.standard.string(forKey: "tagTitle") ?? ""  == title ? "" : title, forKey: "tagTitle")
                                }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
                                .font(.subheadline)
                                .foregroundColor(searchOptions.tagTitle == title ? Color.white : Color(hex: "44556b"))
                                .background(searchOptions.tagTitle == title  ?
                                                RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                                                RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
                                )
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            VStack {
                HStack(alignment: .center) {
                    Text("ロウリュ").font(.headline).foregroundColor(Color(hex: "44556b")).fontWeight(.bold)
                    Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 5))
                
                HStack {
                    optionLoyly
                    optionSelfLoyly
                    optionAutoLoyly
                }
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
            
            
            VStack {
                HStack(alignment: .center) {
                    Text("休憩").font(.headline).foregroundColor(Color(hex: "44556b")).fontWeight(.bold)
                    Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 5))
                
                HStack {
                    optionRestSpace
                    optionGaikiYoku
                }
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        }.padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15)).background(mainColor)
            
    }
    
    
    
    var searchOptionsRoleView: some View {
        VStack {
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(searchOptions.rolesList.keys.reversed(), id: \.self) { key in
                        let value = searchOptions.rolesList[key]
                        Button(value!) {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            let impactLig = UIImpactFeedbackGenerator(style: .light)
                            searchOptions.rolesState[key]!! ? impactMed.impactOccurred() : impactLig.impactOccurred()
                            searchOptions.rolesState[key]!!.toggle()
                            let role = searchOptions.rolesState[key]!! ? true : nil
                            UserDefaults.standard.setValue(role, forKey: key)
                        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
                        .font(.subheadline)
                        .foregroundColor(searchOptions.rolesState[key]!! ? Color.white : Color(hex: "44556b"))
                        .background(searchOptions.rolesState[key]!!  ?
                                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
                        )
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }
                }.padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
            }
        }
        
    }
    
    
    var searchOptionsAmenityView: some View {
        VStack {
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(searchOptions.amenityList.keys.reversed(), id: \.self) { key in
                        let value = searchOptions.amenityList[key]
                        Button(value!) {
                            
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            let impactLig = UIImpactFeedbackGenerator(style: .light)
                            searchOptions.amenityState[key]!! ? impactMed.impactOccurred() : impactLig.impactOccurred()
                            searchOptions.amenityState[key]!!.toggle()
                            let amenity = searchOptions.amenityState[key]!! ? true : nil
                            UserDefaults.standard.setValue(amenity, forKey: key)
                        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
                        .font(.subheadline)
                        .foregroundColor(searchOptions.amenityState[key]!! ? Color.white : Color(hex: "44556b"))
                        .background(searchOptions.amenityState[key]!!  ?
                                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
                        )
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }
                }.padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
            }
        }
        
    }
    
    var optionLoyly: some View {
        Button("アウフグース") {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            let impactLig = UIImpactFeedbackGenerator(style: .light)
            searchOptions.loyly! ? impactMed.impactOccurred() : impactLig.impactOccurred()
            searchOptions.loyly?.toggle()
            let loyly = searchOptions.loyly! ? true : nil
            UserDefaults.standard.setValue(loyly, forKey: "loyly")
        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
        .font(.subheadline)
        .foregroundColor(searchOptions.loyly! ? Color.white : Color(hex: "44556b"))
        .background(searchOptions.loyly! ?
                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
        ).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
    
    var optionSelfLoyly: some View {
        Button("セルフ") {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            let impactLig = UIImpactFeedbackGenerator(style: .light)
            searchOptions.selfLoyly! ? impactMed.impactOccurred() : impactLig.impactOccurred()
            searchOptions.selfLoyly?.toggle()
            let selfLoyly = searchOptions.selfLoyly! ? true : nil
            UserDefaults.standard.setValue(selfLoyly, forKey: "selfLoyly")
            
        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
        .font(.subheadline)
        .foregroundColor(searchOptions.selfLoyly! ? Color.white : Color(hex: "44556b"))
        .background(searchOptions.selfLoyly! ?
                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
        ).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
    
    var optionAutoLoyly: some View {
        Button("オート") {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            let impactLig = UIImpactFeedbackGenerator(style: .light)
            searchOptions.autoLoyly! ? impactMed.impactOccurred() : impactLig.impactOccurred()
            searchOptions.autoLoyly?.toggle()
            let autoLoyly = searchOptions.autoLoyly! ? true : nil
            UserDefaults.standard.setValue(autoLoyly, forKey: "autoLoyly")
        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
        .font(.subheadline)
        .foregroundColor(searchOptions.autoLoyly! ? Color.white : Color(hex: "44556b"))
        .background(searchOptions.autoLoyly! ?
                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
        ).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
    
    
    var optionGaikiYoku: some View {
        Button("外気浴") {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            let impactLig = UIImpactFeedbackGenerator(style: .light)
            searchOptions.gaikiYoku! ? impactMed.impactOccurred() : impactLig.impactOccurred()
            searchOptions.gaikiYoku?.toggle()
            let gaikiYoku = searchOptions.gaikiYoku! ? true : nil
            UserDefaults.standard.setValue(gaikiYoku, forKey: "gaikiYoku")
        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
        .font(.subheadline)
        .foregroundColor(searchOptions.gaikiYoku! ? Color.white : Color(hex: "44556b"))
        .background(searchOptions.gaikiYoku! ?
                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
        ).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
    
    
    var optionRestSpace: some View {
        Button("休憩スペース") {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            let impactLig = UIImpactFeedbackGenerator(style: .light)
            searchOptions.restSpace! ? impactMed.impactOccurred() : impactLig.impactOccurred()
            searchOptions.restSpace?.toggle()
            let restSpace = searchOptions.restSpace! ? true : nil
            UserDefaults.standard.setValue(restSpace, forKey: "restSpace")
        }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
        .font(.subheadline)
        .foregroundColor(searchOptions.restSpace! ? Color.white : Color(hex: "44556b"))
        .background(searchOptions.restSpace! ?
                        RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow() :
                        RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow()
        ).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
    }
}
