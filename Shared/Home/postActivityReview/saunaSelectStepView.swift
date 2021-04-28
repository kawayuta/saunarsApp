//
//  saunaSelectStepView.swift
//  saucialApp
//
//  Created by kawayuta on 4/24/21.
//

import Foundation
import SwiftUI
import Combine

struct saunaSelectStepView: View {
    
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            incrementalSearchFieldView(viewModel: viewModel)
        }
    }
}

struct incrementalSearchFieldView: View {
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            searchTextField
            searchResultView.frame(height: 485)
        }.ignoresSafeArea()
    }
    
    var searchTextField: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            TextField("サウナを検索して選択", text: $viewModel.keyword, onEditingChanged: { isBegin in
                if isBegin {print(122222)} else { print("未入力中です。") }
            }, onCommit: {
            }).onReceive(viewModel.$keyword) { _ in
                viewModel.searchIncrementalSaunaList()
                print(1111)
            }
            .padding()
                .frame(maxWidth: .infinity, maxHeight: 50)
            .padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 15))
                .foregroundColor(.black)
                .accentColor(Color("000"))
                .font(.title3)
            .background(RoundedRectangle(cornerRadius: 30).fill(mainColor)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30),
                                             darkShadow: .gray,
                                             lightShadow: .white,
                                             spread: 0.05, radius: 2)
                            )
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22)
                    .foregroundColor(Color(hex: "ccc"))
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                Spacer()
                if viewModel.keyword != "" {
                    Button("✗") { viewModel.keyword = "" }
                        .frame(width: 22)
                        .foregroundColor(Color(hex: "bbb"))
                        .background(Color(hex: "DDD"))
                        .cornerRadius(11)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
                }
                
            }
        }.frame(height: 45)
    }
    
    var searchResultView: some View {
        VStack {
            Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            ScrollView {
                ForEach(viewModel.saunas.indices, id: \.self) { index in
                    HStack {
                        
                        URLImageView("\(API.init().imageUrl)\(String(describing: viewModel.saunas[index].image.url))")
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(25)
                        VStack(alignment: .leading) {
                            Text(viewModel.saunas[index].name_ja).font(.title3, weight:.bold)
                            Text(viewModel.saunas[index].address).font(.subheadline)
                        }
                        Spacer()
                        Button("選択") {
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            
                            viewModel.selectedTab = 1
                            viewModel.paramsSaunaId = viewModel.saunas[index].id
                            viewModel.selectSaunaTitle = viewModel.saunas[index].name_ja
                        }
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color.blue)
                        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
                    }
                    Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                }
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            }
        }
    }
    
}
