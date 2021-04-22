//
//  SaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/26/21.
//

import SwiftUI

struct SaunaView: View {
    var sauna: Saunas?
    @StateObject var viewModel: MapViewModel
    @State private var selectedRoomsTab: Int = 0
    @State private var selectedRolesTab: Int = 0
    @State private var selectedTab: Int = 0

        let tabs: [Tab] = [
            .init(title: "タイムライン"),
            .init(title: "サウナマップ")
        ]

    init(sauna: Saunas? = nil, viewModel: MapViewModel) {
        self.sauna = sauna
        _viewModel =  StateObject(wrappedValue: viewModel)
    }
    
    var saunaId = String(describing: UserDefaults.standard.string(forKey: "saunaId")!)
    var body: some View {
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Tabs
                // Views
                TabView(selection: $selectedTab,
                        content: {
                            ForEach(viewModel.saunas.indices, id: \.self) { index in
                                Text(viewModel.saunas[index].name_ja).tag(index)
                                self.sauna = viewModel.saunas[index]
                                SaunaSingleView
                            }
                        })
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .foregroundColor(Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ホーム")
            .ignoresSafeArea()
        }
        
        
    }
    
    
    var rooms: some View {
        VStack {
            Picker("", selection: $selectedRoomsTab) {
                ForEach(sauna!.rooms.indices, id: \.self) { roomsindex in
                    let _sauna = sauna!.rooms.reversed()[roomsindex]
                    Text(_sauna.gender == 0 ? "男湯" : "女湯").tag(roomsindex)
                        .font(.caption, weight: .bold)
                        .foregroundColor(Color.white)
                        .frame(width: 20, height: 20)
                        .background(_sauna.gender == 0 ? Color.blue : Color.red)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            
            TabView(selection: $selectedRoomsTab) {
                    ForEach(sauna!.rooms.indices, id: \.self) { roomsindex in
                        let _sauna = sauna!.rooms.reversed()[roomsindex]
                        
                        VStack {
                            HStack(alignment: .top) {
                                VStack {
                                    HStack(alignment: .bottom) {
                                        Text("\(_sauna.sauna_temperature)").font(.largeTitle).fontWeight(.bold).foregroundColor(.red)
                                        Text("℃").font(.title2).fontWeight(.bold).foregroundColor(.red)
                                    }
                                    .padding(1)
                                    Text("サウナ室 温度").font(.headline).fontWeight(.bold).foregroundColor(.red)
                                }.frame(maxWidth: .infinity, alignment: .top)
                                
                                Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(width: 1, height: 80)
                                
                                VStack {
                                    HStack(alignment: .bottom) {
                                        Text("\(_sauna.mizu_temperature)").font(.largeTitle).fontWeight(.bold).foregroundColor(.blue)
                                        Text("℃").font(.title2).fontWeight(.bold).foregroundColor(.blue)
                                    }
                                    .padding(1)
                                    Text("水風呂 温度").font(.headline).fontWeight(.bold).foregroundColor(.blue)
                                }.frame(maxWidth: .infinity, alignment: .top)
                                
                            }.tag(roomsindex)
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                            
                            Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(height: 1)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
    }
    
    var rolesAndAmenities: some View {
        VStack {
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
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            
            TabView(selection: $selectedRolesTab) {
                
                roles
                VStack {
                    ForEach(sauna!.amenities.indices, id: \.self) { rolesindex in
                        let _sauna = sauna!.amenities.reversed()[rolesindex]
                    }
                }.tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }.tag(0)
    }
    
    var roles: some View {
        VStack {
            let _sauna = sauna!.roles[0]
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            Group {
                Text("アウフグース \(String(_sauna.loyly ? "○" : "✗"))").foregroundColor(_sauna.loyly ? .blue : .black)
                    .fontWeight(_sauna.loyly ? .bold : .regular)
                Text("セルフロウリュ \(String(_sauna.self_loyly ? "○" : "✗"))").foregroundColor(_sauna.self_loyly ? .blue : .black)
                    .fontWeight(_sauna.self_loyly ? .bold : .regular)
                Text("オートロウリュ \(String(_sauna.auto_loyly ? "○" : "✗"))").foregroundColor(_sauna.auto_loyly ? .blue : .black)
                    .fontWeight(_sauna.auto_loyly ? .bold : .regular)
                Text("アウフグース \(String(_sauna.free_time ? "○" : "✗"))").foregroundColor(_sauna.free_time ? .blue : .black)
                    .fontWeight(_sauna.free_time ? .bold : .regular)
                Text("セルフロウリュ \(String(_sauna.capsule_hotel ? "○" : "✗"))").foregroundColor(_sauna.capsule_hotel ? .blue : .black)
                    .fontWeight(_sauna.capsule_hotel ? .bold : .regular)
                Text("オートロウリュ \(String(_sauna.in_rest_space ? "○" : "✗"))").foregroundColor(_sauna.in_rest_space ? .blue : .black)
                    .fontWeight(_sauna.in_rest_space ? .bold : .regular)
                Text("アウフグース \(String(_sauna.eat_space ? "○" : "✗"))").foregroundColor(_sauna.eat_space ? .blue : .black)
                    .fontWeight(_sauna.eat_space ? .bold : .regular)
                Text("セルフロウリュ \(String(_sauna.wifi ? "○" : "✗"))").foregroundColor(_sauna.wifi ? .blue : .black)
                    .fontWeight(_sauna.wifi ? .bold : .regular)
                Text("オートロウリュ \(String(_sauna.power_source ? "○" : "✗"))").foregroundColor(_sauna.power_source ? .blue : .black)
                    .fontWeight(_sauna.power_source ? .bold : .regular)
                Text("オートロウリュ \(String(_sauna.work_space ? "○" : "✗"))").foregroundColor(_sauna.work_space ? .blue : .black)
                    .fontWeight(_sauna.work_space ? .bold : .regular)
            }.font(.caption)
            Group {
                Text("アウフグース \(String(_sauna.manga ? "○" : "✗"))").foregroundColor(_sauna.manga ? .blue : .black)
                Text("セルフロウリュ \(String(_sauna.body_care ? "○" : "✗"))").foregroundColor(_sauna.body_care ? .blue : .black)
                Text("オートロウリュ \(String(_sauna.body_towel ? "○" : "✗"))").foregroundColor(_sauna.body_towel ? .blue : .black)
                Text("アウフグース \(String(_sauna.water_dispenser ? "○" : "✗"))").foregroundColor(_sauna.water_dispenser ? .blue : .black)
                Text("セルフロウリュ \(String(_sauna.washlet ? "○" : "✗"))").foregroundColor(_sauna.washlet ? .blue : .black)
                Text("オートロウリュ \(String(_sauna.credit_settlement ? "○" : "✗"))").foregroundColor(_sauna.credit_settlement ? .blue : .black)
                Text("アウフグース \(String(_sauna.parking_area ? "○" : "✗"))").foregroundColor(_sauna.parking_area ? .blue : .black)
                Text("セルフロウリュ \(String(_sauna.ganbanyoku ? "○" : "✗"))").foregroundColor(_sauna.ganbanyoku ? .blue : .black)
                Text("オートロウリュ \(String(_sauna.tattoo ? "○" : "✗"))").foregroundColor(_sauna.tattoo ? .blue : .black)
            }.font(.caption)
            }.padding(15)
        }
    }
    
    var SaunaSingleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(sauna!.name_ja).font(.title).fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
            
            Text(sauna!.address).font(.subheadline)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            
            HStack {
                    HStack {
                        Image(systemName: "yensign.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(Color(hex: "44556b"))
                        Text(String(sauna!.price)).font(.subheadline)
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 0))
                
                    HStack {
                        Image(systemName: "car.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(Color(hex: "44556b"))
                        Text(String(sauna!.parking)).font(.subheadline)
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            }
            
            Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(height: 1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            
            rooms
            rolesAndAmenities
            
            VStack(spacing: 0) {
            
                URLImageView("http://localhost:3000/sauna_images/\(String(describing: sauna!.id)).jpg", cacheClear: false)
                    .cornerRadius(15)
                    .aspectRatio(contentMode: .fit)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            }
        }
    }
         
}
