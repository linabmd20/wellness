//
//  WellnessAppApp.swift
//  WellnessApp
//
//  Created on iOS
//

import SwiftUI

@main
struct WellnessAppApp: App {
    @StateObject private var healthManager = HealthManager()
    @StateObject private var dataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .environmentObject(dataStore)
        }
    }
}

