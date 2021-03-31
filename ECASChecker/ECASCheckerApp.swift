//
//  ECASCheckerApp.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import SwiftUI
import WidgetKit

@main
struct ECASCheckerApp: App {
    
    init() {
        WidgetCenter.shared.reloadTimelines(ofKind: "ECASCheckerWidget")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
