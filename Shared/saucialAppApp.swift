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
import Lottie


@main
struct saucialAppApp: App {
    
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    private let userDefaults = UserDefaults.standard
    @State var LoginCheck: Bool = false
    @ObservedObject var viewModel = AuthViewModel(mode: .signup)
    @StateObject var appModel = SaunaviMessageViewModel()
    var body: some Scene {
        WindowGroup {
            
            VStack {
                if LoginCheck {
                    HomeView().environmentObject(Keyboard()).environmentObject(appModel)
                        .environmentObject(MapViewModel())
                        .environmentObject(RecommendViewModel())
                        .environmentObject(TimelineViewModel())
                        .environmentObject(UserViewModel())
                        .sendEventLog(.lanch)
                } else {
                    LoadingAnimatedView(LoginCheck: $LoginCheck)
                        .frame(width: UIScreen.main.bounds.height / 2)
                }
                
            }.onAppear() {
                viewModel.autoSignUpIn(completion: { completion in
                    if completion {
                        LoginCheck = true
                    }
                })
            }
        }
    }
}

#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    
    
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
        

        return true
    }
    
}
#endif


struct LoadingAnimatedView: UIViewRepresentable {
    @Binding var LoginCheck: Bool
    var name = "load"
        var loopMode: LottieLoopMode = .loop
    
    init (LoginCheck: Binding<Bool>) {
        _LoginCheck = LoginCheck
    }
    func makeUIView(context: UIViewRepresentableContext<LoadingAnimatedView>) -> UIView {
           let view = UIView(frame: .zero)

           let animationView = AnimationView()
           let animation = Animation.named(name)
           animationView.animation = animation
           animationView.contentMode = .scaleAspectFit
           animationView.loopMode = loopMode
           animationView.play() { (status) in
                print(status)
           }

           animationView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(animationView)
           NSLayoutConstraint.activate([
               animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
               animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
           ])

           return view
       }

       func updateUIView(_ uiView: UIViewType, context: Context) {
       }
}
