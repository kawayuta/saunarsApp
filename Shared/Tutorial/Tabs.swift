//
//  TabsView.swift
//  saucialApp
//
//  Created by kawayuta on 3/13/21.
//

import SwiftUI

struct Tab {
    var icon: Image?
    var title: String
}

struct Tabs: View {
    var fixed = true
    var tabs: [Tab]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            Button(action: {
                                withAnimation {
                                    selectedTab = row
                                }
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        // Image
//                                        AnyView(tabs[row].icon)
//                                            .foregroundColor(.white)
//                                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))

                                        // Text
                                        Text(tabs[row].title)
                                            .font(Font.system(size: 15, weight: .semibold))
                                            .foregroundColor(selectedTab == row ? Color.blue : Color(hex:"44556b"))
                                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                                    }
                                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count) - 6): .none, height: 52)
                                    // Bar Indicator
//                                    Rectangle().fill(selectedTab == row ? Color.white : Color.clear)
//                                        .frame(height: 3)
                                }.fixedSize()
                            })
                            .background(RoundedCorners(tl: 10, tr: 10, bl: 0, br: 0)
                                            .fill(selectedTab == row ? Color.white : Color(hex:"E9EFF4")))
                            .accentColor(Color.white)
                            .buttonStyle(PlainButtonStyle())
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
    }
}

struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs(fixed: true,
             tabs: [.init(icon: Image(systemName: "star.fill"), title: "Tab 1"),
                    .init(icon: Image(systemName: "star.fill"), title: "Tab 2"),
                    .init(icon: Image(systemName: "star.fill"), title: "Tab 3")],
             geoWidth: .infinity,
             selectedTab: .constant(0))
    }
}
