//
//  saucialAppApp.swift
//  Shared
//
//  Created by kawayuta on 3/11/21.
//

import Siren
import SwiftUI
import PartialSheet
import KeyboardObserving
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import Firebase


@main
struct saucialAppApp: App {
    
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    private let userDefaults = UserDefaults.standard
    var body: some Scene {
        WindowGroup {
            SaunaMapView().environmentObject(PartialSheetManager()).environmentObject(Keyboard())
                .sendEventLog(.lanch)
        }
    }
}

#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    
    @ObservedObject var viewModel = AuthViewModel(mode: .signup)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(forceLanguageLocalization: .japanese)
        siren.rulesManager = RulesManager(
            majorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), // A.b.c.d
            minorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), // a.B.c.d
            patchUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), // a.b.C.d
            revisionUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force) // a.b.c.D
        )
        siren.wail()
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            FirebaseApp.configure()
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        })
        
        
            viewModel = AuthViewModel(mode: .mypage)
            viewModel.autoSignUpIn(completion: { signUpCompletion in
            })

        return true
    }
}
#endif
