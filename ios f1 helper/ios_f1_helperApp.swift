//
//  ios_f1_helperApp.swift
//  F1 Monk
//
//  Created by vishal s on 3/2/25.
//

import SwiftUI

@main
struct ios_f1_helperApp: App {
    init() {
        // Force dark mode for the entire app
        UIWindow.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .preferredColorScheme(.dark)
        }
    }
}
