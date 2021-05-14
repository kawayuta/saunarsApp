//
//  FirebaseAnalyticsTracker.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/19/21.
//

import FirebaseAnalytics
import SwiftUI

final class FirebaseAnalyticsTracker {
    enum Event: String {
        case login
        case lanch
    }

    func sendEventLog(_ event: Event, parameters: [String: Any] = [:]) {
        if API.init().host == API.HostType.production {
            Analytics.logEvent(event.rawValue, parameters: parameters)
        }
    }

    enum UserProperty: String {
        case level
    }

    func setUserProperty(key: UserProperty, value: String) {
        if API.init().host == API.HostType.production {
            Analytics.setUserProperty(value, forName: key.rawValue)
        }
    }
}

extension View {
    func sendEventLog(_ eventName: FirebaseAnalyticsTracker.Event, parameters: [String: Any] = [:]) -> Self {
        FirebaseAnalyticsTracker().sendEventLog(eventName, parameters: parameters)
        return self
    }

    func setUserProperty(key: FirebaseAnalyticsTracker.UserProperty, value: String) -> Self {
        FirebaseAnalyticsTracker().setUserProperty(key: key, value: value)
        return self
    }
}
