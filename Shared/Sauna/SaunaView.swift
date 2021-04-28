//
//  SaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/27/21.
//

import SwiftUI
import SwiftUIPager
import SwiftUIX
import FeedKit

struct SaunaView: View {
    @StateObject var viewModel: SaunaViewModel
    
    @State private var selectedRolesTab: Int = 0
    @State var selectedRoomsTab: Int = 0
    @State var selectedMain: Int = 0
    
    @State private var loaded: Bool = false
    @StateObject var page: Page = .first()
    var items = Array(0..<10)
    let mainColor = Color.Neumorphic.main
    @State var openWebVisible: Bool = false
    @State var openInfoWebVisible: Bool = false
    @State var itemWebUrl: String = ""
    
    init(sauna_id: String) {
        _viewModel = StateObject(wrappedValue: SaunaViewModel(sauna_id: sauna_id))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let sauna = viewModel.sauna {
                ScrollView (.vertical) {
                    let image_url = sauna.image.url
                    VStack(alignment: .leading, spacing: 0) {
                        URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 250)
                            .clipped()
                        headerView.foregroundColor(Color.black)

                        mainBody
                    }
                    .padding(EdgeInsets(top:0, leading: 0, bottom: 30, trailing: 0))
                }.ignoresSafeArea()
                .background(RoundedRectangle(cornerRadius: 0).fill(mainColor))
            }
        }
        .ignoresSafeArea()
        .background(RoundedRectangle(cornerRadius: 0).fill(mainColor))
        .onAppear() {
            viewModel.fetchSauna()
            if !loaded {
                loaded = true
            }
        }
        
    }
}


extension SaunaView {
    
    var mainBody: some View {
        
        VStack {
            if viewModel.sauna != nil {
                if viewModel.atomFeed == nil && viewModel.rssFeed == nil && viewModel.jsonFeed == nil {
                } else {
                    Picker("", selection: $selectedMain) {
                        Text("施設情報").tag(0)
                        Text("お知らせ").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                }
                
                if selectedMain == 0 { main }
                else { information }
            }
        }
    }
    
    
    var main: some View {
        VStack {
            if let sauna = viewModel.sauna {
                
                Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                HStack(alignment: .top) {
                    ReviewChartView(viewModel: viewModel)
                    WentButtonView(viewModel: .init(mode: .went, sauna_id: String(sauna.id)))
                }.frame(height: 200)
                rooms
                rolesAndAmenities
                fundamentalInformation
                HStack { Spacer(); if sauna.hp != "" { openWeb } }
            }
        }
    }
    
    var information: some View {
        VStack {
            feedAtom
            feedRss
            feedJson
        }
    }
    
}

extension SaunaView {
    
    func strValueOptionalCheck(text: String?) -> String { // Defining the function
        guard let text = text else { return "" }
        if text != "" { return text }
        else { return "" }
    }
    
    var feedAtom: some View {
        VStack(alignment: .leading) {
            if let feed = viewModel.atomFeed, let items = feed.entries {
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            
                            Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            Text(items[index].title!).font(.title3, weight: .bold)
                                .padding(EdgeInsets(top:0, leading: 0, bottom: 1, trailing: 0))
                            Text(strValueOptionalCheck(text: items[index].summary!.value))
                                .lineLimit(2)
                                .font(.subheadline)
                        }.onTapGesture {
                            if items[index].links?.first?.attributes?.href != "" {
                                itemWebUrl = (items[index].links?.first?.attributes?.href)!
                                DispatchQueue.main.async {
                                    openInfoWebVisible.toggle()
                                }
                            }
                        }
                        .padding(EdgeInsets(top:5, leading: 15, bottom: 0, trailing: 15))
                    }
                }
            }
        }
        .sheet(isPresented: $openInfoWebVisible) {
            WebView(urlString: itemWebUrl)
        }
    }
    
    var feedRss: some View {
        VStack(alignment: .leading) {
            if let feed = viewModel.rssFeed, let items = feed.items {
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            
                            Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            Text(items[index].title!).font(.title3, weight: .bold)
                                .padding(EdgeInsets(top:0, leading: 0, bottom: 1, trailing: 0))
                            Text(items[index].description!).font(.subheadline)
                                .lineLimit(2)
                        }.onTapGesture {
                            if items[index].link != "" {
                                itemWebUrl = items[index].link!
                                DispatchQueue.main.async {
                                    openInfoWebVisible.toggle()
                                }
                            }
                        }
                        .padding(EdgeInsets(top:5, leading: 15, bottom: 0, trailing: 15))
                    }
                }
                
            }
        }
        .sheet(isPresented: $openInfoWebVisible) {
            WebView(urlString: itemWebUrl)
        }
    }
    
    var feedJson: some View {
        VStack(alignment: .leading) {
            if let feed = viewModel.jsonFeed, let items = feed.items  {
                LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    ForEach(items.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            
                            Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            Text(items[index].title!).font(.title3, weight: .bold)
                                .padding(EdgeInsets(top:0, leading: 0, bottom: 1, trailing: 0))
                            if let summary = items[index].summary {
                                Text(summary.description).font(.subheadline)
                                    .lineLimit(2)
                            }
                        }.onTapGesture {
                            if items[index].url != "" {
                                itemWebUrl = items[index].url!
                                DispatchQueue.main.async {
                                    openInfoWebVisible.toggle()
                                }
                            }
                        }
                        .padding(EdgeInsets(top:5, leading: 15, bottom: 0, trailing: 15))
                    }
                }
            }
        }
        .sheet(isPresented: $openInfoWebVisible) {
            WebView(urlString: itemWebUrl)
        }
    }
    
    var openWeb: some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            openWebVisible.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "link")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22)
                                .foregroundColor(Color(hex: "44556b"))
                                .padding(EdgeInsets(top:2, leading: 0, bottom: 0, trailing: 2))
                            Text("公式サイト")
                        }
        })
        .sheet(isPresented: $openWebVisible) {
            if let sauna = viewModel.sauna {
                WebView(urlString: sauna.hp)
            }
        }
        .frame(width: 130, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top:30, leading: 15, bottom: 0, trailing: 15))
    }
    
    var rooms: some View {
        VStack {
            if let sauna = viewModel.sauna {
                
                Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                Picker("", selection: $selectedRoomsTab) {
                    ForEach(sauna.rooms.indices, id: \.self) { roomsindex in
                        let _sauna = sauna.rooms.reversed()[roomsindex]
                        Text(_sauna.gender == 0 ? "男湯" : "女湯").tag(roomsindex)
                            .font(.caption, weight: .bold)
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                            .background(_sauna.gender == 0 ? Color.blue : Color.red)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
                
                Pager(page: Page.withIndex(selectedRoomsTab),
                      data: sauna.rooms.indices,
                      id: \.self,
                      content: { index in
                        let _sauna = sauna.rooms.reversed()[index]
                            
                        HStack(alignment: .top) {
                            if let sauna_temperature =  _sauna.sauna_temperature {
                                VStack {
                                    HStack(alignment: .bottom) {
                                        Text("\(sauna_temperature)").font(.largeTitle).fontWeight(.bold).foregroundColor(.red)
                                        Text("℃").font(.title2).fontWeight(.bold).foregroundColor(.red)
                                    }
                                    .padding(1)
                                    Text("サウナ室 温度").font(.headline).fontWeight(.bold).foregroundColor(.red)
                                }.frame(maxWidth: .infinity, alignment: .top)
                            }

                            Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(width: 1, height: 80)

                            if let mizu_temperature =  _sauna.mizu_temperature {
                                VStack {
                                    HStack(alignment: .bottom) {
                                        Text("\(mizu_temperature)").font(.largeTitle).fontWeight(.bold).foregroundColor(.blue)
                                        Text("℃").font(.title2).fontWeight(.bold).foregroundColor(.blue)
                                    }
                                    .padding(1)
                                    Text("水風呂 温度").font(.headline).fontWeight(.bold).foregroundColor(.blue)
                                }.frame(maxWidth: .infinity, alignment: .top)
                            }
                            
                            

                        }.tag(index)
                      })
                    .onPageChanged({ (newIndex) in
                        selectedRoomsTab = newIndex
                    })
                }
            
            Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
        }.frame(height: 165)
    }
    
    
    
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let sauna = viewModel.sauna {
                Text(sauna.name_ja).font(.title).fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
                Text(sauna.address).font(.subheadline)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))

            HStack {
                HStack {
                    Image(systemName: "yensign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(Color(hex: "44556b"))
                    Text(String(sauna.price)).font(.subheadline)
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 0))
                HStack {
                    Image(systemName: "car.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(Color(hex: "44556b"))
                    Text(String(sauna.parking)).font(.subheadline)
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            }
        }
    }
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
}
    var fundamentalInformation: some View {
        VStack(alignment: .leading) {
            if let sauna = viewModel.sauna {
                Text("基本情報")
                    .font(.title3, weight: .bold)
                    .foregroundColor(Color.black)
                
                LazyVGrid(columns: [GridItem(.fixed(50)), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    Text("施設名:")
                        .font(.body, weight: .bold)
                        .frame(alignment: .leading)
                    Text("\(sauna.name_ja)")
                    
                    Text("住所:")
                        .font(.body, weight: .bold)
                        .frame(alignment: .leading)
                    Text("\(sauna.address)")
                    
                    Text("TEL:")
                        .font(.body, weight: .bold)
                        .frame(alignment: .leading)
                    Text("\(sauna.tel)")
                    
                    Text("HP:")
                        .font(.body, weight: .bold)
                    Text("\(sauna.hp)")
                    
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    var rolesAndAmenities: some View {
            VStack {
                if viewModel.sauna != nil {
                    Picker("", selection: $selectedRolesTab) {
                        Text("設備・ルール").tag(0)
                            .font(.caption, weight: .bold)
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                        
                        Text("アメニティ").tag(1)
                            .font(.caption, weight: .bold)
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                    
                    GeometryReader { proxy in
                            Pager(page:Page.withIndex(selectedRolesTab),
                                  data: 0..<2,
                                  id: \.self,
                                  content: { index in
                                    amenities
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                        .tag(1)
                                    roles
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                        .tag(0)
                                    
                                })
                                .onPageChanged({ (newIndex) in
                                    selectedRolesTab = newIndex
                                })
                                .frame(width: proxy.size.width, height: min(proxy.size.height, proxy.size.width))
                    }.frame(minHeight: 250)
                }
                

                Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            }
    }

    struct SaunaInfoStyle: ViewModifier {
        let status: Bool
        func body(content: Content) -> some View {
            HStack {
                content
            }
            .font(.subheadline, weight: status ? .bold : .regular)
            .foregroundColor(status ? .blue : .gray)
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        }
    }
    
    var roles: some View {
        VStack {
            if let sauna = viewModel.sauna?.roles[0] {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            Group {
                Text("アウフグース").modifier(SaunaInfoStyle(status: sauna.loyly))
                Text("セルフロウリュ").modifier(SaunaInfoStyle(status: sauna.self_loyly))
                Text("オートロウリュ").modifier(SaunaInfoStyle(status: sauna.auto_loyly))
                Text("24時間営業").modifier(SaunaInfoStyle(status: sauna.free_time))
                Text("カプセルホテル").modifier(SaunaInfoStyle(status: sauna.capsule_hotel))
                Text("休憩スペース").modifier(SaunaInfoStyle(status: sauna.in_rest_space))
                Text("食事処").modifier(SaunaInfoStyle(status: sauna.eat_space))
                Text("WiFi").modifier(SaunaInfoStyle(status: sauna.wifi))
                Text("電源").modifier(SaunaInfoStyle(status: sauna.power_source))
                Text("作業スペース").modifier(SaunaInfoStyle(status: sauna.work_space))
            }
            Group {
                Text("漫画").modifier(SaunaInfoStyle(status: sauna.manga))
                Text("ボディケア").modifier(SaunaInfoStyle(status: sauna.body_care))
                Text("ボディタオル").modifier(SaunaInfoStyle(status: sauna.body_towel))
                Text("冷水機").modifier(SaunaInfoStyle(status: sauna.water_dispenser))
                Text("ウォシュレット").modifier(SaunaInfoStyle(status: sauna.washlet))
                Text("クレジット決済").modifier(SaunaInfoStyle(status: sauna.credit_settlement))
                Text("駐車場").modifier(SaunaInfoStyle(status: sauna.parking_area))
                Text("岩盤浴").modifier(SaunaInfoStyle(status: sauna.ganbanyoku))
                Text("タトゥーOK").modifier(SaunaInfoStyle(status: sauna.tattoo))
            }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
        }
        }
    }

    
    var amenities: some View {
        VStack {
            if let sauna = viewModel.sauna?.amenities[0] {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            Group {
                Text("シャンプー").modifier(SaunaInfoStyle(status: sauna.shampoo))
                Text("コンディショナー").modifier(SaunaInfoStyle(status: sauna.conditioner))
                Text("ボディソープ").modifier(SaunaInfoStyle(status: sauna.body_soap))
                Text("フェイスソープ").modifier(SaunaInfoStyle(status: sauna.face_soap))
                Text("カミソリ").modifier(SaunaInfoStyle(status: sauna.razor))
                Text("歯ブラシ").modifier(SaunaInfoStyle(status: sauna.toothbrush))
                Text("ナイロンタオル").modifier(SaunaInfoStyle(status: sauna.nylon_towel))
                Text("ヘアドライヤー").modifier(SaunaInfoStyle(status: sauna.hairdryer))
                Text("フェイスタオル").modifier(SaunaInfoStyle(status: sauna.face_towel_unlimited))
                Text("バスタオル").modifier(SaunaInfoStyle(status: sauna.bath_towel_unlimited))
            }
            Group {
                Text("サウナパンツ").modifier(SaunaInfoStyle(status: sauna.sauna_underpants_unlimited))
                Text("サウナマット").modifier(SaunaInfoStyle(status: sauna.sauna_mat_unlimited))
                Text("ビート板").modifier(SaunaInfoStyle(status: sauna.flutterboard_unlimited))
                Text("化粧水").modifier(SaunaInfoStyle(status: sauna.toner))
                Text("乳液").modifier(SaunaInfoStyle(status: sauna.emulsion))
                Text("メイク落とし").modifier(SaunaInfoStyle(status: sauna.makeup_remover))
                Text("綿棒").modifier(SaunaInfoStyle(status: sauna.cotton_swab))
            }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
        }
        }
    }
    
}
