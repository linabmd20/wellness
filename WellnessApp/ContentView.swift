//
//  ContentView.swift
//  WellnessApp
//
//  Main navigation view
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
                .tag(1)
            
            ExerciseView()
                .tabItem {
                    Label("Exercise", systemImage: "figure.run")
                }
                .tag(2)
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife")
                }
                .tag(3)
            
            SleepView()
                .tabItem {
                    Label("Sleep", systemImage: "moon.fill")
                }
                .tag(4)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(5)
        }
        .accentColor(.green)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
        .environmentObject(DataStore())
}

