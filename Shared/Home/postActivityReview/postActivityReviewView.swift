//
//  postReviewView.swift
//  saucialApp
//
//  Created by kawayuta on 4/23/21.
//

import SwiftUI
import Neumorphic
import SwiftUIPager
import SwiftUIX

struct postActivityReviewView: View {
    
    @Binding var isPresent: Bool
    @Binding var myPageVisible: Bool
    @State private var buttonTitles: [String] = ["決定", "次へ", "次へ", "投稿"]
    @State private var naviTitles: [String] = ["行ったサウナ施設を選択", "サウナ施設を評価", "ととのいルーティンを選択", "投稿内容を入力"]
    @StateObject var viewModel: ReviewViewModel
    @StateObject var mapViewModel: MapViewModel
    
    init(mapViewModel: MapViewModel, isPresent: Binding<Bool>, myPageVisible: Binding<Bool>) {
        _mapViewModel = StateObject(wrappedValue: mapViewModel)
        _viewModel = StateObject(wrappedValue: ReviewViewModel(mapViewModel: mapViewModel))
        _isPresent = isPresent
        _myPageVisible = myPageVisible
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(naviTitles[viewModel.selectedTab]).font(.title, weight: .bold)
                Spacer()
//                Text("1/3").font(.title2, weight: .bold)
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 20))
            
//            secondStepView(viewModel: viewModel)
            if viewModel.selectedTab == 0 { saunaSelectStepView(viewModel: viewModel) }
            if viewModel.selectedTab == 1 { reviewView(viewModel: viewModel) }
            if viewModel.selectedTab == 2 { routineView(viewModel: viewModel) }
            if viewModel.selectedTab == 3 { postBodyView(viewModel: viewModel) }
//
            if viewModel.selectedTab != 0 {
                Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                HStack {
                    Button("←") {
                        
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        if viewModel.selectedTab != 0 { viewModel.selectedTab -= 1 }
                    }.frame(minWidth: 55, maxWidth: 55, minHeight: 55, maxHeight: 55).font(.title)
                    .foregroundColor(Color.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "bcbcbc")).softOuterShadow())
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    
                    Button(buttonTitles[viewModel.selectedTab]) {
                        print(viewModel.saunaRoutineValideteState)
                        print(viewModel.mizuRoutineValideteState)
                        print(viewModel.restRoutineValideteState)
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()
                        
                        if viewModel.selectedTab == 2 {
                            viewModel.saunaRoutineValidete()
                            viewModel.mizuRoutineValidete()
                            viewModel.restRoutineValidete()
                            viewModel.setTextDefaultBody()
                            viewModel.selectedTab += 1
                            print(viewModel.paramsTextArea)
                        } else if viewModel.selectedTab == 3 {
                            viewModel.postReview(completion: { [self] postReviewCompletion in
                                print(postReviewCompletion)
                            })
                            viewModel.postActivity(completion: { [self] postActivityCompletion in
                                print(postActivityCompletion)
                            })
                            isPresent = false
                            myPageVisible = true
                        } else { viewModel.selectedTab += 1 }
                    }.frame(minWidth: 80, maxWidth: .infinity, minHeight: 55, maxHeight: 55).font(.title)
                    .foregroundColor(Color.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow())
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .disabled((viewModel.selectedTab == 2
                                && [viewModel.saunaRoutineValideteState,
                                    viewModel.mizuRoutineValideteState,
                                    viewModel.restRoutineValideteState].contains(false)))
                    .disabled(viewModel.selectedTab == 3
                                && !viewModel.textAreaValidateState)
                }
            }
        }
        .navigationBarHidden(true).ignoresSafeArea()
    }
}
