//
//  firstStepView.swift
//  saucialApp
//
//  Created by kawayuta on 4/23/21.
//

import SwiftUI

struct routineView: View {
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            sessionRoutineHeader()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            sessionRoutineSaunaView(viewModel: viewModel).frame(height: 60)
            if !viewModel.saunaRoutineValideteState {
                Text("正しい時間と回数を設定してください").foregroundColor(.red)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 20))
            }
            Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                .padding(EdgeInsets(top: 15, leading: 95, bottom: 15, trailing: 15))
            
            
            sessionRoutineMizuView(viewModel: viewModel).frame(height: 60)
            if !viewModel.mizuRoutineValideteState {
                Text("正しい時間と回数を設定してください").foregroundColor(.red)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 20))
            }
            Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                .padding(EdgeInsets(top: 15, leading: 95, bottom: 15, trailing: 15))
            
            
            sessionRoutineRestView(viewModel: viewModel).frame(height: 60)
            if !viewModel.restRoutineValideteState {
                Text("正しい時間と回数を設定してください").foregroundColor(.red)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 20))
            }
        }
    }
}


struct sessionRoutineHeader: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack(alignment: .center, spacing: 0) {
                    Text("").frame(width: 80, height: 60, alignment: .center)
                    Text("時間").frame(maxWidth: geometry.size.width / 2 - 45, alignment: .center)
                        .font(.headline, weight: .bold).foregroundColor(Color(hex: "44556b"))
                    Text("回数").frame(maxWidth: geometry.size.width / 2 - 55, alignment: .center)
                        .font(.headline, weight: .bold).foregroundColor(Color(hex: "44556b"))
                }
            }.frame(height: 20)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        }.frame(height: 20)
    }
}

struct sessionRoutineSaunaView: View {
    
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Text("サウナ").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                        .frame(width: 80, height: 60, alignment: .center)
                }
                
                HStack {
                    VStack(spacing: 0) {
                        Picker(
                            selection: $viewModel.selectedSaunaColumn,
                            label: Text("Selected column")
                        ){
                            ForEach(viewModel.saunaColumn.indices, id: \.self) { index in
                                Text("\(viewModel.saunaColumn[index]) 分")
                            }
                        }
                        .onChange(of: viewModel.selectedSaunaColumn) {
                            if $0 == 0 {
                                viewModel.selectedSaunaColumn = 0
                                viewModel.selectedSaunaRow = 0
                            }
                            viewModel.saunaRoutineValidete()
                            print(viewModel.saunaRoutineValideteState)
                        }
                        .frame(maxWidth: geometry.size.width / 2 - 60, maxHeight: 60)
                        .clipped()
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    VStack(spacing: 0) {
                        Picker(
                            selection: $viewModel.selectedSaunaRow,
                            label: Text("Selected row")
                        ){
                            ForEach(viewModel.saunaRow.indices, id: \.self) { index in
                                Text("\(viewModel.saunaRow[index]) 回")
                            }
                        }
                        .onChange(of: viewModel.selectedSaunaRow) {
                            if $0 == 0 {
                                viewModel.selectedSaunaColumn = 0
                                viewModel.selectedSaunaRow = 0
                            }
                            viewModel.saunaRoutineValidete()
                        }
                        .frame(maxWidth: geometry.size.width / 2 - 60, maxHeight: 60)
                        .clipped()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(mainColor)
                                .softInnerShadow(RoundedRectangle(cornerRadius: 10),
                                                 darkShadow: .gray,
                                                 lightShadow: .white,
                                                 spread: 0.05, radius: 2)
                                )
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        
    }
    
}



struct sessionRoutineMizuView: View {
    
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Text("水風呂").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                        .frame(width: 80, height: 60, alignment: .center)
                }
                
                HStack {
                    VStack(spacing: 0) {
                        Picker(
                            selection: $viewModel.selectedMizuColumn,
                            label: Text("Selected column")
                        ){
                            ForEach(viewModel.mizuColumn.indices, id: \.self) { index in
                                Text("\(viewModel.mizuColumn[index]) 分")
                            }
                        }
                        .onChange(of: viewModel.selectedMizuColumn) {
                            if $0 == 0 {
                                viewModel.selectedMizuColumn = 0
                                viewModel.selectedMizuRow = 0
                            }
                            viewModel.mizuRoutineValidete()
                            print(viewModel.mizuRoutineValideteState)
                        }
                        .frame(maxWidth: geometry.size.width / 2 - 60, maxHeight: 60)
                        .clipped()
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    VStack(spacing: 0) {
                        Picker(
                            selection: $viewModel.selectedMizuRow,
                            label: Text("Selected row")
                        ){
                            ForEach(viewModel.mizuRow.indices, id: \.self) { index in
                                Text("\(viewModel.mizuRow[index]) 回")
                            }
                        }
                        .onChange(of: viewModel.selectedMizuRow) {
                            if $0 == 0 {
                                viewModel.selectedMizuColumn = 0
                                viewModel.selectedMizuRow = 0
                            }
                            viewModel.mizuRoutineValidete()
                        }
                        .frame(maxWidth: geometry.size.width / 2 - 60, maxHeight: 60)
                        .clipped()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(mainColor)
                                .softInnerShadow(RoundedRectangle(cornerRadius: 10),
                                                 darkShadow: .gray,
                                                 lightShadow: .white,
                                                 spread: 0.05, radius: 2)
                                )
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        
    }
    
}




struct sessionRoutineRestView: View {
    
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    Text("休憩").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                        .frame(width: 80, height: 60, alignment: .center)
                }
                
                HStack {
                    VStack(spacing: 0) {
                        Picker(
                            selection: $viewModel.selectedRestColumn,
                            label: Text("Selected column")
                        ){
                            ForEach(viewModel.restColumn.indices, id: \.self) { index in
                                Text("\(viewModel.restColumn[index]) 分")
                            }
                        }
                        .onChange(of: viewModel.selectedRestColumn) {
                            if $0 == 0 {
                                viewModel.selectedRestColumn = 0
                                viewModel.selectedRestRow = 0
                            }
                            viewModel.restRoutineValidete()
                            print(viewModel.restRoutineValideteState)
                        }
                        .frame(maxWidth: geometry.size.width / 2 - 60, maxHeight: 60)
                        .clipped()
                    }
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    VStack(spacing: 0) {
                        Picker(
                            selection: $viewModel.selectedRestRow,
                            label: Text("Selected row")
                        ){
                            ForEach(viewModel.restRow.indices, id: \.self) { index in
                                Text("\(viewModel.restRow[index]) 回")
                            }
                        }
                        .onChange(of: viewModel.selectedRestRow) {
                            if $0 == 0 {
                                viewModel.selectedRestColumn = 0
                                viewModel.selectedRestRow = 0
                            }
                            viewModel.restRoutineValidete()
                        }
                        .frame(maxWidth: geometry.size.width / 2 - 60, maxHeight: 60)
                        .clipped()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(mainColor)
                                .softInnerShadow(RoundedRectangle(cornerRadius: 10),
                                                 darkShadow: .gray,
                                                 lightShadow: .white,
                                                 spread: 0.05, radius: 2)
                                )
                
            }
        }
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
}


extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
