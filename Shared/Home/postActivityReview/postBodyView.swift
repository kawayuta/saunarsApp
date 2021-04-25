//
//  postBodyView.swift
//  saucialApp
//
//  Created by kawayuta on 4/24/21.
//

import SwiftUI
import SwiftUIX

struct postBodyView: View {
    
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            bodyView(viewModel: viewModel)
        }
    }
}

struct bodyView: View {
   
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            textBodyArea
        }
    }
    
    var textBodyArea: some View {
        VStack(alignment: .trailing) {
            TextView(text: $viewModel.paramsTextArea.onChange(perform: { _ in viewModel.textAreaValidate()
                print(viewModel.textAreaValidateState)
            })).isFirstResponder(true)
            .padding()
            .foregroundColor(.black).font(.title3)
            .background(RoundedRectangle(cornerRadius: 0)
                            .fill(mainColor)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 0),
                                                 darkShadow: .gray,
                                                 lightShadow: .white,
                                                 spread: 0.01, radius: 2)
                )
            Text("\(viewModel.paramsTextArea.count) / 300文字")
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .foregroundColor(viewModel.paramsTextArea.count <= 300 ? .black : .red)
        }.frame(height: 250)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
    }
    
}
