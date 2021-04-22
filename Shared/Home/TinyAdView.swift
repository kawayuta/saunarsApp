//
//  TinyAdView.swift
//  saucialApp
//
//  Created by kawayuta on 4/18/21.
//

import SwiftUI
import GoogleMobileAds
struct TinyAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
        banner.adUnitID = "ca-app-pub-2934182617348947/4183641993"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}

struct TinyAdView_Previews: PreviewProvider {
    static var previews: some View {
        TinyAdView()
    }
}
