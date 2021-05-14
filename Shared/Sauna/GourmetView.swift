//
//  GourmetView.swift
//  saucialApp
//
//  Created by kawayuta on 5/10/21.
//

import SwiftUI
import SwiftUIX
import PartialSheet
import SwiftUIPager

struct GourmetView: View {
    
    @StateObject var viewModel = GourmetViewModel()
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State var previewVisible: Bool = false
    let mainColor = Color.Neumorphic.main
    var lat: String
    var lng: String
    @State var selectTab: Int = 0
    
    
    init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text("サウナ施設に近い順").font(.title3, weight: .bold)
                .padding(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 15))
            LazyVGrid(columns: [GridItem(.flexible(minimum: 0, maximum: .infinity))], alignment: .leading, spacing: 10) {
                if let shop = viewModel.shop {
                    ForEach(shop.indices, id: \.self) { index in
                        VStack {
                            HStack(alignment: .top) {
                                URLImageView((shop[index].photo?.mobile?.l)!)
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .clipped()
                                    .aspectRatio(1, contentMode: .fit)
                                GourmetCardInfoView(shop: shop[index])
                                Spacer()
                            }
                        }
                        .backgroundFill(.white)
                        .cornerRadius(8)
                        .clipped()
                        .onTapGesture {
                            if !previewVisible {
                                selectTab = index
                                previewVisible = true
                            }
                        }
                        .partialSheet(isPresented: $previewVisible) {
                            PaginationView(showsIndicators: true) {
                                ForEach(shop.indices, id: \.self) { index in
                                    GourmetCardInfoSheetView(shop: shop[index], previewVisible: $previewVisible).tag(index)
                                }
                            }.cyclesPages(true)
                            .pageIndicatorAlignment(.bottom)
                            .interPageSpacing(0)
                            .currentPageIndex($selectTab)
                            .currentPageIndicatorTintColor(.blue)
                            .pageIndicatorTintColor(Color(hex: "DEDEDE"))
                            .frame(height: 550)
                            .padding(EdgeInsets(top:-30, leading: 0, bottom: 70, trailing: 0))
//                            TabView(selection: $selectTab) {
//                                ForEach(shop.indices, id: \.self) { index in
//                                    GourmetCardInfoSheetView(shop: shop[index], previewVisible: $previewVisible)
//                                        .tag(index)
//                                }
//                            }
//                            .frame(height: 520)
//                            .tabViewStyle(PageTabViewStyle())
//                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//                            .padding(EdgeInsets(top:-5, leading: 0, bottom: 70, trailing: 0))
                            
                        }
                    }
                }
                
            }
            .padding(EdgeInsets(top:0, leading: 15, bottom: 0, trailing: 15))

        }.onAppear() {
            viewModel.fetchGourmet(lat: lat, lng: lng)
        }
    }
    
}

struct GourmetCardInfoSheetView: View {
    
    var shop: GourmetShop
    let mainColor = Color.Neumorphic.main
    @Binding var previewVisible: Bool
    
    init(shop: GourmetShop, previewVisible: Binding<Bool>) {
        self.shop = shop
        _previewVisible = previewVisible
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                URLImageView((shop.photo?.pc?.l ?? shop.photo?.pc?.m ?? shop.photo?.mobile?.l ?? shop.photo?.mobile?.s)!)
                    .scaledToFill()
                    .frame(height: 230)
                    .clipped()
                Button(action: {
                    previewVisible = false
                    
                }, label: {
                    HStack {
                      Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height:25)
                            .foregroundColor(Color(hex: "FFF"))
                            .padding(EdgeInsets(top:15, leading: 0, bottom: 0, trailing: 15))
                            .shadow(radius: 5)
                    }
                })
            }
            
            Group {
            Text(shop.name ?? "").font(.title2, weight: .bold)
                .lineLimit(1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
            Text(shop.access ?? "").font(.subheadline)
                .lineLimit(1)
                .foregroundColor(.gray)
           
            Text(shop.genre?.name ?? "")
                .font(.subheadline)
                .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                .background(Color(hex: "E6B2B5"))
                .cornerRadius(3)
            
            HStack {
                Image(systemName: "yensign.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                    .foregroundColor(Color(hex: "44556b"))
                Text(shop.budget?.name ?? "")
                    .font(.title3)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
            
        
            HStack {
                Image(systemName: "car.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                    .foregroundColor(Color(hex: "44556b"))
                Text(shop.parking ?? "無し").font(.subheadline)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
            
                HStack {
                    Text("営業時間： ").font(.headline)
                        .lineLimit(1)
                        .foregroundColor(Color(hex: "44556b"))
                    Text(shop.open ?? "情報なし").font(.subheadline)
                        .lineLimit(1)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
                
                HStack {
                    Text("カード支払い： ").font(.headline)
                        .lineLimit(1)
                        .foregroundColor(Color(hex: "44556b"))
                    Text(shop.card ?? "無し").font(.subheadline)
                        .lineLimit(1)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
            }
            .padding(EdgeInsets(top:0, leading: 15, bottom: 0, trailing: 15))
            
            openMap
        }.frame(height: 550)
    }
    
    
    
    var openMap: some View {
        
        GeometryReader { geo in
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            let latitude = String(shop.lat!)
            let longitude = String(shop.lng!)
            
            let urlString: String!
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                urlString = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=walking&zoom=14"
            } else {
                urlString = "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=w"
            }
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
            
        }, label: {
            HStack {
              Text("マップアプリで開く")
                .foregroundColor(Color(hex: "FFF"))
            }
        })
        .frame(width: geo.size.width - 30, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.blue).softOuterShadow())
        .padding(EdgeInsets(top:15, leading: 15, bottom: 0, trailing: 15))
        }
    }
    
    var close: some View {
        
        GeometryReader { geo in
        Button(action: {
            previewVisible = false
            
        }, label: {
            HStack {
              Image(systemName: "xmark")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 22)
                  .foregroundColor(Color(hex: "FFF"))
                  .padding(EdgeInsets(top:2, leading: 0, bottom: 0, trailing: 2))
              Text("閉じる")
                .foregroundColor(Color(hex: "000"))
            }
        })
        .frame(width: geo.size.width - 30, height: 50)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(hex: "DEDEDE")).softOuterShadow())
        .padding(EdgeInsets(top:15, leading: 15, bottom: 0, trailing: 15))
        }
    }
    
}




struct GourmetCardInfoView: View {
    
    var shop: GourmetShop
    let mainColor = Color.Neumorphic.main
    
    init(shop: GourmetShop) {
        self.shop = shop
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(shop.name ?? "").font(.headline, weight: .bold)
                .lineLimit(1)
            Text(shop.access ?? "").font(.subheadline)
                .lineLimit(1)
                .foregroundColor(.gray)
           
            Text((shop.genre?.name)!)
                .font(.subheadline)
                .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
                .background(Color(hex: "E6B2B5"))
                .cornerRadius(3)
            
            Spacer()
            
            HStack {
                Image(systemName: "car.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                    .foregroundColor(Color(hex: "44556b"))
                Text(shop.parking ?? "無し").font(.subheadline)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
            
            HStack {
                Image(systemName: "yensign.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18)
                    .foregroundColor(Color(hex: "44556b"))
                Text((shop.budget?.name)!)
                    .lineLimit(1)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
        }
        .padding(EdgeInsets(top:10, leading: 5, bottom: 10, trailing: 15))
    }
}
