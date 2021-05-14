//
//  WentButtonView.swift
//  saucialApp
//
//  Created by kawayuta on 3/14/21.
//

import SwiftUI
import StoreKit

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
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }, label: {
                Text(viewModel.state ? "イキタイ済" : "イキタイ！")
                    .font(.title3)
            })
            .frame(maxWidth: 150, maxHeight: 50, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15).fill(viewModel.state ? .blue : Color.white).softOuterShadow())
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(viewModel.state ? .white : Color.blue, lineWidth: 1))
            .padding(EdgeInsets(top:0, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(viewModel.state ? .white : .blue)
        }
    }
    
    var body: some View {
        wentButton
    }
}
