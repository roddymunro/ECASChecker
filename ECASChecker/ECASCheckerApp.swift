//
//  ECASCheckerApp.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import SwiftUI
import WidgetKit
import UserNotifications

@main
struct ECASCheckerApp: App {
    
    init() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "ECASCheckerWidget")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
