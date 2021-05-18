//
//  SaunaRecommendView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/29/21.
//

import SwiftUI
import Neumorphic
import SwiftUIX

struct SaunaRecommendView: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    let mainColor = Color.Neumorphic.main
    @State var selectedMain: Int = 0
    @EnvironmentObject var saunaviViewModel: SaunaviMessageViewModel
    @EnvironmentObject var viewModel: RecommendViewModel
    @State var saunaInfoVisible: Bool = false
    @State var tabs: [Tab] = [
        Tab(title: "現在地 ✗ 厳選"),
        Tab(title: "全国厳選")
    ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geo in
                Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedMain)
            }.frame(height: 50)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
            .background(Color(hex: "E9EFF4"))
            
            Rectangle().foregroundColor(Color(hex:"DDD")).frame(height: 1)
            
            TabView(selection: $selectedMain) {
                LocationRecommend(saunaInfoVisible: $saunaInfoVisible, locationSaunas: $viewModel.locationSaunas).tag(0)
                AllRecommend(saunaInfoVisible: $saunaInfoVisible, saunas: $viewModel.saunas).tag(1)
//                AllRecommend(saunaInfoVisible: $saunaInfoVisible, saunas: $viewModel.saunas).tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
        }
        .sheet(isPresented: $saunaInfoVisible) {
            SaunasView(saunas: selectedMain == 0 ? $viewModel.locationSaunas : $viewModel.saunas)
        }
    }
    
    
}

struct AllRecommend: View {
    
    @EnvironmentObject var viewModel: RecommendViewModel
    @Binding var saunas: [Sauna]
    @Binding var saunaInfoVisible: Bool
    @State private var isPullShowing = false
    
    init(saunaInfoVisible: Binding<Bool>, saunas: Binding<[Sauna]>) {
        _saunaInfoVisible = saunaInfoVisible
        _saunas = saunas
    }
    
    var body: some View {
        ScrollView {
            RefreshControl(coordinateSpace: .named("RefreshControl")) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.searchSaunaList(writeRegion: false, completion: { _ in })
                }
            }
            LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                    if saunas.count > 0 {
                        ForEach(saunas.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 0) {
                                let image_url = saunas[index].image.url
                                URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxHeight: 250)
                                    .clipped()
                                contentView(sauna: saunas[index])
                            }.onTapGesture {
                                UserDefaults.standard.setValue(index, forKey: "selectTabSaunaView")
                                saunaInfoVisible = true
                            }
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        }
                    } else {
                        Text("厳選サウナが見つかりませんでした")
                    }
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.coordinateSpace(name: "RefreshControl")
    }
}



struct LocationRecommend: View {
    
    @EnvironmentObject var viewModel: RecommendViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    @Binding var saunaInfoVisible: Bool
    @Binding var locationSaunas: [Sauna]
    @State private var isPullShowing = false
    
    init(saunaInfoVisible: Binding<Bool>, locationSaunas: Binding<[Sauna]>) {
        _saunaInfoVisible = saunaInfoVisible
        _locationSaunas = locationSaunas
    }
    
    
    var body: some View {
        ScrollView {
            RefreshControl(coordinateSpace: .named("RefreshControl")) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.searchLocationSaunaList(writeRegion: false,
                                                      currentLatitude: String(mapViewModel.currentRegion.center.latitude),
                                                      currentLongitude: String(mapViewModel.currentRegion.center.longitude)
                    )
                }
            }
            LazyVGrid(columns: [GridItem(.flexible())], alignment: .center, spacing: 0) {
                if locationSaunas.count > 0 {
                    ForEach(locationSaunas.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 0) {
                            let image_url = locationSaunas[index].image.url
                            URLImageView("\(API.init().imageUrl)\(String(describing: image_url))")
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: 250)
                                .clipped()
                            contentView(sauna: locationSaunas[index])
                        }.onTapGesture {
                            UserDefaults.standard.setValue(index, forKey: "selectTabSaunaView")
                            saunaInfoVisible = true
                        }
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    }
                } else {
                    Text("厳選サウナが見つかりませんでした")
                }
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.coordinateSpace(name: "RefreshControl")
    }
}



struct contentView: View {
    
    var sauna: Sauna
    init(sauna: Sauna) {
        self.sauna = sauna
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                Text(sauna.name_ja).font(.title2).fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                Text(sauna.address).font(.subheadline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))

            HStack {
                HStack {
                    Image(systemName: "yensign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(Color(hex: "44556b"))
                    
                    let price = sauna.price == 0 ? "情報なし" : String(sauna.price.withComma)
                    Text(String(price)).font(.title3)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                HStack {
                    Image(systemName: "car.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22)
                        .foregroundColor(Color(hex: "44556b"))
                    Text(String(sauna.parking)).font(.title3)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            }
            VStack(alignment: .leading, spacing: 0) {
                ForEach(sauna.rooms.indices, id: \.self) { rolesindex in
                    HStack {
                        let room = sauna.rooms.reversed()[rolesindex]
                        Text(room.gender == 0 ? "男" : "女")
                            .foregroundColor(Color.white)
                            .font(.headline)
                            .fontWeight(.regular)
                            .frame(width: 30, height: 30)
                            .background(room.gender == 0 ? Color.blue : Color.red)
                            .cornerRadius(10)
                        
                        if let sauna_temperature = room.sauna_temperature {
                            Text("サ")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30)
                                .background(Color(hex: "E9EFF4"))
                                .cornerRadius(10)
                            let saunaTemperature = sauna_temperature == 0 ? "✗" : "\(sauna_temperature)℃"
                            Text("\(saunaTemperature)").font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 50)
                        }
                        if let mizu_temperature = room.mizu_temperature {
                            Text("水")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30)
                                .background(Color(hex: "E9EFF4"))
                                .cornerRadius(10)
                            let mizuTemperature = mizu_temperature == 0 ? "✗" : "\(mizu_temperature)℃"
                            Text("\(mizuTemperature)").font(.headline)
                                .foregroundColor(.black)
                                .frame(width: 50)
                        }
                        
                        Text("外")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .background(Color(hex: "E9EFF4"))
                            .cornerRadius(10)
                        Text(sauna.roles.contains {$0.loyly == true} ? "○" : "✗").font(.headline)
                            .foregroundColor(.black)
                        Text("ロ")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .background(Color(hex: "E9EFF4"))
                            .cornerRadius(10)
                        Text(sauna.roles.contains {$0.gaikiyoku == true} ? "○" : "✗").font(.headline)
                            .foregroundColor(.black)
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                }
            }
        }
        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
    }
}

extension Bundle {
  
  public var icon: UIImage? {
    
    if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
       let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
       let files = primary["CFBundleIconFiles"] as? [String],
       let icon = files.last
    {
      return UIImage(named: icon)
    }
    
    return nil
  }
}
