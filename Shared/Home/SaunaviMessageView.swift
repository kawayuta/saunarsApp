//
//  SaunaviMessageView.swift
//  saucialApp
//
//  Created by kawayuta on 5/2/21.
//

import SwiftUI

struct SaunaviMessageView: View {
    @EnvironmentObject var viewModel: SaunaviMessageViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var recommendViewModel: RecommendViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                SaunaviIcon()
                Text(viewModel.message).font(.headline, weight: .bold)
                    .padding()
                    .background(.white)
                    .cornerRadius(5)
            }
            .frame(height: 40)
        }.onAppear() {
//            viewModel.message = "おはよう"
        }
        .onReceive(mapViewModel.$saunas, perform: { _ in
            DispatchQueue.main.async {
                viewModel.message = "\(mapViewModel.saunas.count)件のサウナ施設が見つかったよ！"
            }
        })
        .onReceive(recommendViewModel.$locationSaunas, perform: { _ in
            DispatchQueue.main.async {
                viewModel.message = "イキタイ！をするほど、学習するんだ！"
            }
        })
        .onReceive(recommendViewModel.$saunas, perform: { _ in
            DispatchQueue.main.async {
                viewModel.message = "あなたが好きそうなサウナを厳選したよ"
            }
        })
    }
}

struct SaunaviMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SaunaviMessageView()
    }
}

struct SaunaviIcon: View {
    @State var angle: Double = 0.0
    @State var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 10.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Button(action: {}, label: {
                Group {
                    Image(uiImage: Bundle.main.icon ?? UIImage())
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 40, height: 40)
                .background(.blue)
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.white))
//                .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
//                .animation(self.foreverAnimation)
                .onAppear {
                    self.isAnimating = true
                }
        })
    }
}
