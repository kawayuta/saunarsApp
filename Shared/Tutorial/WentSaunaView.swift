//
//  WentSaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/12/21.
//

import SwiftUI
import PartialSheet
import UIKit
import SwiftUIX

let coloredNavAppearance = UINavigationBarAppearance()


struct WentSaunaView: View {
    
    
    @StateObject var viewModel: WentSaunaViewModel
    @State var complateButtonVisibleState: Bool = false
    
    init(viewModel: WentSaunaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.viewModel.fetchSaunaList()
        
    }
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    var optionButton: some View {
        Button("人気順 ▼") {
            self.partialSheetManager.showPartialSheet(content: {
                OptionView().frame(height: 300)
            })
        }
        .frame(maxWidth: 120, maxHeight: 40, alignment: .center)
        .background(Color.init(hex: "BBB"))
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 15))
    }
    
    
    
    var complateButton: some View {
        Button("完了") {
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .none)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(EdgeInsets(top: 20, leading: 15, bottom: 25, trailing: 15))
        .hidden(complateButtonVisibleState)
    }
    
    var SearchFieldView: some View {
        TextField("検索", text: $viewModel.keyword, onEditingChanged: { isBegin in
            complateButtonVisibleState = isBegin
            if isBegin {
                print("入力中です。")
            } else {
                print("未入力中です。")
            }
        }, onCommit: {
            if viewModel.keyword.count > 0 {
                viewModel.searchSaunaList()
            } else {
               viewModel.fetchSaunaList()
            }
        }).padding()
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color(hex: "EEE"))
            .foregroundColor(.black)
            .accentColor(Color("000"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 10))
        .keyboardType(.webSearch)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    SearchFieldView
                    optionButton
                        .frame(maxWidth: 120, maxHeight: .none, alignment: .center)
                }
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(viewModel.saunas.indices, id: \.self) { index in
                            HStack(alignment: .top) {
                                URLImageView("\(API.init().host)/sauna_images/\(viewModel.saunas[index].id).jpg")
                                    .frame(width: 60, height: 60, alignment: .leading)
                                    .cornerRadius(10)
                                    .aspectRatio(contentMode: .fit)
                                VStack(alignment: .leading) {
                                    Text( String.init(describing: viewModel.saunas[index].name_ja))
                                        .frame(width: .infinity, height: 25, alignment: .top)
                                        .font(.headline)
                                        .onTapGesture {
                                        UserDefaults.standard.setValue(viewModel.saunas[index].id, forKey: "saunaId")
                                        self.partialSheetManager.showPartialSheet(content: {
                                            SaunaSmallView().frame(height: 400)
                                        })
                                        }
                                    Text(viewModel.saunas[index].address)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
//                                WentButtonView(viewModel: .init(mode: .went, sauna_id: String(viewModel.saunas[index].id)), isWent: viewModel.saunas[index].is_went)
                            }
                        }
                    }.listStyle(PlainListStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                complateButton
            }
            .navigationTitle("イッタ！サウナを登録")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .addPartialSheet()
//        .navigationBarTitle("")
//        .navigationBarHidden(true)
//        .onAppear() {
//            self.viewModel.fetchSaunaList()
//        }
    }
}


struct WentSaunaView_Previews: PreviewProvider {
    static var previews: some View {
        WentSaunaView(viewModel: .init(mode: .saunas))
    }
}
