//
//  SaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/26/21.
//

import SwiftUI
import PartialSheet
import SwiftUIX

struct SaunasView: View {
    let mainColor = Color.Neumorphic.main
    @Binding var saunas: [Sauna]
    @State private var selectedRoomsTab: Int = 0
    @State private var selectedRolesTab: Int = 0
    @State var selectedTab: Int = UserDefaults.standard.integer(forKey: "selectTabSaunaView")
    @State var selectTabIndex: Int = 0

    init(saunas: Binding<[Sauna]>) {
        _saunas = saunas
    }
    
    var body: some View {
        
//        PaginationView(axis: .horizontal) {
//            ForEach(viewModel.saunas.indices, id: \.hashValue) { index in
//                SaunaView(sauna_id: String(viewModel.saunas[index].id))
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                    .tag(index).ignoresSafeArea()
//            }
//        }
//        .currentPageIndex($selectedTab)
        TabView(selection: $selectedTab) {
            ForEach(saunas.indices, id: \.self) { index in
                SaunaView(sauna_id: String(saunas[index].id))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
        
        
    }
    
}

