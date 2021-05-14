//
//  WentSaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/12/21.
//

import SwiftUI
import PartialSheet


struct HomeView: View {
    
    @State private var selectedTab: Int = 0

        let tabs: [Tab] = [
            .init(title: "タイムライン"),
            .init(title: "サウナマップ")
        ]
    
    
    init() {
    }
    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            NavigationView { SaunaMapView().navigationBarTitle("サウナマップ",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .environmentObject(SaunaviMessageViewModel())
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("サウナマップ")
                }
                .tag(1)
            NavigationView { SaunaRecommendView().navigationBarTitle("AI厳選（イキタイ！するほど学習するよ）",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "mail.stack.fill")
                    Text("AI厳選")
                }
                .tag(2)
            
            NavigationView { TimelineView().navigationBarTitle("みんなのサ活",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("みんなのサ活")
                }
                .tag(3)
            NavigationView { MyPageView().navigationBarTitle("マイページ",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("マイページ")
                }
                .tag(4)
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
