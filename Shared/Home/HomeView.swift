//
//  WentSaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/12/21.
//

import SwiftUI
import PartialSheet
import SwiftUIPager


struct HomeView: View {
    
    @State private var selectedTab: Int = 0
    
//    @State var tabs: [Tab] = [
//        Tab(title: "現在地 ✗ 厳選"),
//        Tab(title: "現在地 ✗ 厳選"),
//        Tab(title: "現在地 ✗ 厳選"),
//        Tab(title: "全国厳選")
//    ]
    
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "CP Font", size: 20)!,
            .foregroundColor: UIColor.blue
        ]
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            NavigationView { SaunaMapView().navigationBarTitle("サウナマップ",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("サウナマップ")
                }
                .tag(0)
            NavigationView { SaunaRecommendView().navigationBarTitle("AI厳選（イキタイ！するほど学習するよ）",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "mail.stack.fill")
                    Text("AI厳選")
                }
                .tag(1)

            NavigationView { TimelineView().navigationBarTitle("みんなのサ活",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("みんなのサ活")
                }
                .tag(2)
            NavigationView { ActivityView().navigationBarTitle("アクティビティ",displayMode: .inline) }.environmentObject(PartialSheetManager())
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle.fill")
                    Text("アクティビティ")
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
