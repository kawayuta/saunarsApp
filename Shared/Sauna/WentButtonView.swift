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
            Button(viewModel.state ? "行きたい済み" : "行きたい！") {
                viewModel.state ? viewModel.putNotWent() : viewModel.putWent()
                viewModel.state.toggle()
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            .frame(maxWidth: 150, maxHeight: 50, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 20).fill(viewModel.state ? .blue : mainColor).softOuterShadow())
            .padding(EdgeInsets(top:0, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(viewModel.state ? .white : .blue)
        }
    }
    
    var body: some View {
        wentButton
    }
}
