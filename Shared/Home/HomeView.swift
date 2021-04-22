//
//  WentSaunaView.swift
//  saucialApp
//
//  Created by kawayuta on 3/12/21.
//

import SwiftUI


struct HomeView: View {
    
    @State private var selectedTab: Int = 0

        let tabs: [Tab] = [
            .init(title: "タイムライン"),
            .init(title: "サウナマップ")
        ]
    
    
    init() {
    }
    
    
    var body: some View {
        
        NavigationView {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            // Tabs
                            Tabs(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)

                            // Views
                            TabView(selection: $selectedTab,
                                    content: {
                                        SaunaMapView()
                                            .tag(0)
                                        LaunchScreenView()
                                            .tag(1)
                                    })
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                        .foregroundColor(Color(#colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)))
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("ホーム")
                        .ignoresSafeArea()
                    }
                }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
