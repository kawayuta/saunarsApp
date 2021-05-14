//
//  LikeButtonView.swift
//  saucialApp
//
//  Created by kawayuta on 5/9/21.
//

import SwiftUI

struct LikeButtonView: View {
    
    @StateObject var viewModel: LikeButtonViewModel
    let mainColor = Color.Neumorphic.main
    
    init(viewModel: LikeButtonViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.fetchLike()
    }
    
    var likeButton: some View {
        VStack(alignment: .leading) {
            Button(action: {
                viewModel.state ? viewModel.putNotLike() : viewModel.putLike()
                viewModel.state ? (viewModel.like_count -= 1) : (viewModel.like_count += 1)
                viewModel.state.toggle()
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }, label: {
                VStack {
                    HStack {
                        Spacer()
                        HStack {
                            Image(systemName: viewModel.state ? "heart.fill" : "heart.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15)
                                    .foregroundColor(viewModel.state ? .white : .gray)
                            Text("イイネ！").font(.subheadline, weight: .bold)
                                .foregroundColor(viewModel.state ? .white : .gray)
                        }
                        
                        if viewModel.like_count != 0 {
                            Text("✗ \(viewModel.like_count)").font(.subheadline)
                                .foregroundColor(viewModel.state ? .white : .gray)
                        }
                        Spacer()
//                        Text(viewModel.state ? "いいね！" : "いいね！").font(.title3)
                    }
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 10))
                }.background(viewModel.state ? .pink : mainColor)
            })
        }
    }
    
    var body: some View {
        likeButton
    }
}
