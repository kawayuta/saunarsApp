//
//  SaunaMapView.swift
//  saucialApp
//
//  Created by kawayuta on 3/23/21.
//

import SwiftUI
import PartialSheet
import Neumorphic
import Cluster
import SwiftUIX

struct SaunaMapView: View {
    
    @StateObject var viewModel = MapViewModel()
    @State var complateButtonVisibleState: Bool = false
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @State var searchOptions = SearchOptions()
    @State var searchOptionVisible: Bool = false
    
    @State var searchVisible: Bool = false
    @State var postReviewVisible: Bool = false
    @State var saunaInfoVisible: Bool = false
    @State var resultCardVisible: Bool = false
    @State var mypageVisible: Bool = false
    let mainColor = Color.Neumorphic.main
    
    @State var showStoreDropDown: Bool = false
    @State var selectedType = SortProperty()
    
    @State var message = ""
    @State var showingAlert = false
    
    @State private var selectedTab: Int = 0
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var searchButton: some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            searchVisible = true
        }, label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22)
                .foregroundColor(Color.blue)
        })
        .partialSheet(isPresented: $searchVisible) {
            searchView(viewModel: viewModel, isPresent: $searchVisible)
        }
        .frame(width: 50, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
    }
    
    
    var currentLocationButton: some View {
        Button(action: {
            viewModel.requestUserLocation()
            viewModel.searchSaunaList(writeRegion: false)
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
                    }, label: {
                        Image(systemName: "location")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(Color(hex: "44556b"))
                            .padding(EdgeInsets(top:2, leading: 0, bottom: 0, trailing: 2))
        })
        .frame(width: 50, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top:0, leading: 30, bottom: 0, trailing: 30))
    }
    
    var postReviewButton: some View {
        
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            postReviewVisible = true
        }, label: {
            Image(systemName: "highlighter")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22)
                .foregroundColor(Color.orange)
                .padding(EdgeInsets(top:2, leading: 0, bottom: 0, trailing: 2))
            Text("サ活記録")
                .foregroundColor(Color.orange)
        })
        .partialSheet(isPresented: $postReviewVisible) {
            postActivityReviewView(mapViewModel: viewModel, isPresent: $postReviewVisible, myPageVisible: $mypageVisible)
        }
        .frame(width: 150, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top:0, leading: 30, bottom: 0, trailing: 30))
        
    }
    
    var myPageButton: some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            mypageVisible.toggle()
                    }, label: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(Color(hex: "44556b"))
                            .padding(EdgeInsets(top:2, leading: 0, bottom: 0, trailing: 2))
        })
        .frame(width: 50, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top:30, leading: 15, bottom: 0, trailing: 15))
    }
    
    var resultCardView: some View {
        
        ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())], alignment: .center, spacing: 8) {
                    ForEach(viewModel.saunas.indices, id: \.self) { index in
                        ZStack {
                            VStack(alignment: .leading) {
                                resultCardMainView(sauna: viewModel.saunas[index])
                                Spacer()
                                resultCardRoomsView(rooms: viewModel.saunas[index].rooms)
                            }.frame(width: 150, height: 200)
                            .contentShape(Rectangle())
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .cornerRadius(20)
                            .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                            .onTapGesture {
                                UserDefaults.standard.setValue(index, forKey: "selectTabSaunaView")
                                saunaInfoVisible = true
                            }
                            .sheet(isPresented: $saunaInfoVisible) {
                                SaunasView(viewModel: viewModel)
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                .frame(height: 250)
        }
        
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                    MapView(viewModel: viewModel, resultState: $resultCardVisible)
                        .sheet(isPresented: $viewModel.tapState) {
                            SaunaView(sauna_id: viewModel.tapSaunaId)
                        }
//                    LiquidSwiper()
                }
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    if resultCardVisible {
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                            resultCardView.hideOnKeyboard()
                            HStack {
                                SortDropDownView(viewModel: viewModel)
                                Spacer()
                            }.padding(EdgeInsets(top: -50, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    
//                    TinyAdView()
//                        .frame(width: .infinity, height:55)
//                        .background(RoundedRectangle(cornerRadius: 0).fill(mainColor).softOuterShadow())
                    
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                        HStack(spacing: 0) {
                            currentLocationButton
                            searchButton
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            Spacer()
                            postReviewButton
                        }
                        
                            NavigationLink("", destination: MyPageView(), isActive: $mypageVisible)
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 40, trailing: 0))
                    .background(RoundedRectangle(cornerRadius: 0).fill(mainColor).softOuterShadow())
                }
                
            }.ignoresSafeArea()
        .background(RoundedRectangle(cornerRadius: 0).fill(mainColor).softOuterShadow())
        .addPartialSheet(style: PartialSheetStyle(background: .solid(mainColor),
                                                          handlerBarColor: Color(UIColor.systemGray2),
                                                          enableCover: true,
                                                          coverColor: Color.black.opacity(0.4),
                                                          blurEffectStyle: nil,
                                                          cornerRadius: 15, minTopDistance: 0))
            .navigationBarTitle("",displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        
                                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                        impactMed.impactOccurred()
                                        mypageVisible.toggle()
                                    }, label: {
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16)
                                            .foregroundColor(Color(hex: "44556b"))
                                        })
                                        .frame(width: 40, height: 40)
                                        .background(RoundedRectangle(cornerRadius: 15).fill(mainColor).softOuterShadow())
            )
        }.onAppear() {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
////                postReviewVisible = true
//                mypageVisible = true
//            }
        }
        
    }
    
    func resize(image: UIImage, width:Double, height: Double, xy: String) -> UIImage {
            
        if xy == "y" {
            if image.size.width != 0 {
                let aspectScale = image.size.width / image.size.height
                let resizedSize = CGSize(width: height * Double(aspectScale), height: height)
                UIGraphicsBeginImageContext(resizedSize)
                image.draw(in: CGRect(x:  0 - (resizedSize.width / 10), y: 0, width: resizedSize.width, height: resizedSize.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return resizedImage!
            } else {
                return UIImage()
            }
        } else {
            if image.size.height != 0 {
                let aspectScale =  image.size.height / image.size.width
                let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
                UIGraphicsBeginImageContext(resizedSize)
                image.draw(in: CGRect(x: 0, y: 0 - (resizedSize.width / 10), width: resizedSize.width, height: resizedSize.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return resizedImage!
            } else {
                return UIImage()
            }
        }
    }
}

struct SaunaMapView_Previews: PreviewProvider {
    static var previews: some View {
        SaunaMapView()
    }
}


struct ItemRow: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.blue.cornerRadius(8)
                Text("1")
            }
            .frame(width: geo.size.height, height: geo.size.width)
            .rotationEffect(.degrees(90), anchor: .topTrailing)
            .transformEffect(.init(translationX: 0, y: geo.size.height))
            .scaleEffect(x: -1, y: 1)
        }
    }
}



