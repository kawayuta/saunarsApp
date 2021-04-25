//
//  WentButtonView.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//

import SwiftUI

struct WentButtonView: View {
    
    @StateObject var viewModel: WentButtonViewModel
    let mainColor = Color.Neumorphic.main
    
    init(viewModel: WentButtonViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.fetchWent()
    }
    
    var wentButton: some View {
        VStack(alignment: .leading) {
            Button(action: {
                viewModel.state ? viewModel.putNotWent() : viewModel.putWent()
                viewModel.state.toggle()
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }, label: {
                Text(viewModel.state ? "行きたい済み" : "行きたい！")
                    .font(.title3)
            })
            .frame(maxWidth: 150, maxHeight: 50, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15).fill(viewModel.state ? .blue : Color.white))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
            .padding(EdgeInsets(top:0, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(viewModel.state ? .white : .blue)
        }
    }
    
    var body: some View {
        wentButton
    }
}
