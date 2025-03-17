//
//  ExampleApp.swift
//  Example
//
//  Created by Alper Tekin on 15.03.2025.
//

import SwiftUI
import SetgreetSDK

@main
struct ExampleApp: App {
    
    init() {
        Setgreet.shared.initialize(
            appKey: "APP_KEY",
            config: .init(
                debugMode: true)
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
