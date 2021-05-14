//
//  SaunaviMessageViewModel.swift
//  saucialApp
//
//  Created by kawayuta on 5/2/21.
//

import Foundation
import SwiftUI

final class SaunaviMessageViewModel: ObservableObject {
    
    @Published var message: String = "行きたいサウナを探そう！"
    @Published var screen: Screen = Screen.map
   
    init(screen: Screen) {
        self.screen = screen
    }
    
    var title: String {
        switch screen {
        case .map:
            return "map"
        case .recommend:
            return "recommend"
        case .activity:
            return "activity"
        }
    }
    
    enum Screen {
        case map
        case recommend
        case activity
    }
    
}
