//
//  SaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/26/21.
//

import SwiftUI
import PartialSheet

struct SaunasView: View {
    @StateObject var viewModel: MapViewModel
    @State private var selectedRoomsTab: Int = 0
    @State private var selectedRolesTab: Int = 0
    @State var selectedTab: Int = UserDefaults.standard.integer(forKey: "selectTabSaunaView")
    @State var selectTabIndex: Int = 0

    init(viewModel: MapViewModel) {
        _viewModel =  StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ForEach(viewModel.saunas.indices, id: \.self) { index in
                SaunaView(sauna_id: String(viewModel.saunas[index].id))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
        
        
    }
    
}

