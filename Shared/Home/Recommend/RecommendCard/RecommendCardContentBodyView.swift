//
//  RecommendCardContentBodyView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/30/21.
//

import SwiftUI
import SwiftUIPager

struct RecommendCardContentBodyView: View {
    
    
    private var sauna: Sauna
    @State private var selectedRolesTab: Int = 0
    @State var selectedRoomsTab: Int = 0
    
    @State var rolesCount: Int = 0
    @State var rolesEvaluation: Int = 0
    @State var amenityCount: Int = 0
    @State var amenityEvaluation: Int = 0
    
    init(sauna: Sauna) {
        self.sauna = sauna
    }
    var body: some View {
        
            ScrollView {
                Text(sauna.name_ja).font(.title3, weight: .bold)
                    .padding(EdgeInsets(top:15, leading: 15, bottom: 10, trailing: 15))
                rooms
                roleAndAmenity
            }
    }
    
    
    var rooms: some View {
        VStack {
            if let sauna = sauna {
                
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
                                        
                                        let saunaTemperature = sauna_temperature == 0 ? "情報なし" : "\(sauna_temperature)℃"
                                        Text("\(saunaTemperature)").font(.largeTitle).fontWeight(.bold).foregroundColor(.red)
                                    }
                                    .padding(1)
                                    Text("サウナ室 温度").font(.headline).fontWeight(.bold).foregroundColor(.red)
                                }.frame(maxWidth: .infinity, alignment: .top)
                            }

                            Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(width: 1, height: 80)

                            if let mizu_temperature =  _sauna.mizu_temperature {
                                VStack {
                                    HStack(alignment: .bottom) {
                                        let mizuTemperature = mizu_temperature == 0 ? "情報なし" : "\(mizu_temperature)℃"
                                        Text("\(mizuTemperature)").font(.largeTitle).fontWeight(.bold).foregroundColor(.blue)
                                    }
                                    .padding(1)
                                    Text("水風呂 温度").font(.headline).fontWeight(.bold).foregroundColor(.blue)
                                }.frame(maxWidth: .infinity, alignment: .top)
                            }
                        }.tag(index)
                      })
                    .disableDragging()
                    .onPageChanged({ (newIndex) in
                        selectedRoomsTab = newIndex
                    })
                }
            
            Rectangle().foregroundColor(Color(hex:"ddd")).frame( height: 1)
        }.frame(height: 165)
        .onAppear() {
            if let value = sauna.roles.first {
                rolesCount = value.trueCount()
            }
            if rolesCount == 0 { rolesEvaluation = 0 }
            if rolesCount <= 3 && rolesCount > 0 { rolesEvaluation = 1 }
            if rolesCount <= 6 && rolesCount > 3 { rolesEvaluation = 2 }
            if rolesCount > 6 { rolesEvaluation = 3 }
            
            amenityCount = (sauna.amenities.first?.trueCount())!
            if amenityCount == 0 { amenityEvaluation = 0 }
            if amenityCount <= 3 && amenityCount > 0 { amenityEvaluation = 1 }
            if amenityCount <= 6 && amenityCount > 3 { amenityEvaluation = 2 }
            if amenityCount > 6 { amenityEvaluation = 3 }
            
        }
    }
    
    
    var roleAndAmenity: some View {
        VStack {
//            HStack {
//                HStack {
//                    Text("設備")
//                    Text("\(rolesCount)")
//                    Text("\(rolesEvaluation == 0 ? "✗" : rolesEvaluation == 1 ? "△" : rolesEvaluation == 2 ? "○" : rolesEvaluation == 3 ? "◎" : "")")
//                }
//                HStack {
//                    Text("アメニティ")
//                    Text("\(amenityEvaluation == 0 ? "✗" : amenityEvaluation == 1 ? "△" : amenityEvaluation == 2 ? "○" : "◎")")
//                }
//            }
            
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
                if selectedRolesTab == 0 {
                    roles.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).tag(0)
                }
                if selectedRolesTab == 1 {
                    amenities.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top).tag(1)
                }
            }.frame(minHeight: 250)
        }
    }
    
    
    var roles: some View {
        VStack {
            if let sauna = sauna.roles.first {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                Group {
                    Text("アウフグース").modifier(SaunaInfoStyle(status: sauna.loyly))
                    Text("セルフロウリュ").modifier(SaunaInfoStyle(status: sauna.self_loyly))
                    Text("オートロウリュ").modifier(SaunaInfoStyle(status: sauna.auto_loyly))
                    Text("外気浴").modifier(SaunaInfoStyle(status: sauna.gaikiyoku))
                    Text("24時間営業").modifier(SaunaInfoStyle(status: sauna.free_time))
                    Text("カプセルホテル").modifier(SaunaInfoStyle(status: sauna.capsule_hotel))
                    Text("休憩スペース").modifier(SaunaInfoStyle(status: sauna.rest_space))
                    Text("館内休憩スペース").modifier(SaunaInfoStyle(status: sauna.in_rest_space))
                    Text("食事処").modifier(SaunaInfoStyle(status: sauna.eat_space))
                    Text("WiFi").modifier(SaunaInfoStyle(status: sauna.wifi))
                }
                Group {
                    Text("電源").modifier(SaunaInfoStyle(status: sauna.power_source))
                    Text("作業スペース").modifier(SaunaInfoStyle(status: sauna.work_space))
                    Text("漫画").modifier(SaunaInfoStyle(status: sauna.manga))
                    Text("ボディケア").modifier(SaunaInfoStyle(status: sauna.body_care))
                    Text("ボディタオル").modifier(SaunaInfoStyle(status: sauna.body_towel))
                    Text("冷水機").modifier(SaunaInfoStyle(status: sauna.water_dispenser))
                    Text("ウォシュレット").modifier(SaunaInfoStyle(status: sauna.washlet))
                    Text("クレジット決済").modifier(SaunaInfoStyle(status: sauna.credit_settlement))
                    Text("駐車場").modifier(SaunaInfoStyle(status: sauna.parking_area))
                    Text("岩盤浴").modifier(SaunaInfoStyle(status: sauna.ganbanyoku))
                }
                Group {
                    Text("タトゥーOK").modifier(SaunaInfoStyle(status: sauna.tattoo))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
        }
        }
    }

    
    var amenities: some View {
        VStack {
            if let sauna = sauna.amenities[0] {
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
}
