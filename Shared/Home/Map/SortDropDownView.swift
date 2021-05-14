//
//  SortDropDownView.swift
//  saucialApp
//
//  Created by kawayuta on 4/21/21.
//

import SwiftUI


struct SortBuilding: Identifiable {
    let id = UUID()
    let title: String
    let type: Int
}

struct SortDropDownView: View {
    
    @State var showStoreDropDown: Bool = false
    @State var selectedType: Int = 0
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let sortButtons: [SortBuilding] = [
        SortBuilding(title: "現在地に近い", type: 0),
        SortBuilding(title: "価格が安い", type: 1),
        SortBuilding(title: "価格が高い", type: 2),
    ]
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            Text("\(sortButtons[selectedType].title) \(showStoreDropDown ? "▲" : "▼")")
                .font(.headline, weight: .bold)
                .frame(width: 145, height: 50)
                .foregroundColor(Color(hex: "44556b"))
                .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        }.overlay (
            VStack {
                if showStoreDropDown {
                    VStack(alignment: .leading, spacing: 4){
                        
                        ForEach(sortButtons.indices, id: \.self){ index in
                            Button(action: {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                selectedType = sortButtons[index].type
                                UserDefaults.standard.setValue(selectedType, forKey: "sortType")
                                showStoreDropDown = false
                                print(selectedType)
                                viewModel.searchSaunaList(writeRegion: false)
                            }, label: {
                                Text("\(sortButtons[index].title) \(index == selectedType ? "✓" : "")")
                                    .font(.headline, weight: .bold)
                            }).frame(width: .none, height: .none, alignment: .center)
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            if index != sortButtons.count - 1 { Divider().background(Color.gray) }
                        }
                        
                    }
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
//                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
            }, alignment: .topLeading
        ).onTapGesture {
            
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                impactMed.impactOccurred()
            showStoreDropDown.toggle()
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
        
        
        
    }
}
