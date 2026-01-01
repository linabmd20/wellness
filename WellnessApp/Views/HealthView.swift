//
//  HealthView.swift
//  WellnessApp
//
//  Health metrics tracking view
//

import SwiftUI

struct HealthView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var showingAddMetric = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Today's Metrics") {
                    HealthMetricRow(
                        title: "Steps",
                        value: "\(Int(healthManager.todaySteps))",
                        unit: "steps",
                        icon: "figure.walk",
                        color: .blue
                    )
                    
                    HealthMetricRow(
                        title: "Calories Burned",
                        value: "\(Int(healthManager.todayCalories))",
                        unit: "kcal",
                        icon: "flame.fill",
                        color: .orange
                    )
                    
                    HealthMetricRow(
                        title: "Distance",
                        value: String(format: "%.2f", healthManager.todayDistance),
                        unit: "km",
                        icon: "location.fill",
                        color: .green
                    )
                    
                    HealthMetricRow(
                        title: "Heart Rate",
                        value: healthManager.heartRate > 0 ? "\(Int(healthManager.heartRate))" : "N/A",
                        unit: "bpm",
                        icon: "heart.fill",
                        color: .red
                    )
                }
                
                Section("Health Tips") {
                    TipRow(
                        icon: "heart.circle.fill",
                        title: "Stay Active",
                        description: "Aim for at least 10,000 steps per day"
                    )
                    
                    TipRow(
                        icon: "drop.fill",
                        title: "Stay Hydrated",
                        description: "Drink 8 glasses of water daily"
                    )
                    
                    TipRow(
                        icon: "sun.max.fill",
                        title: "Get Sunlight",
                        description: "Spend 15-30 minutes outside daily"
                    )
                }
            }
            .navigationTitle("Health")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        healthManager.fetchTodayData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct HealthMetricRow: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text("\(value) \(unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct TipRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HealthView()
        .environmentObject(HealthManager())
}

