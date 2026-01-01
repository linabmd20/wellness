//
//  DashboardView.swift
//  WellnessApp
//
//  Main dashboard showing overview of health metrics
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back!")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Here's your wellness overview")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Quick Stats
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(
                            title: "Steps",
                            value: "\(Int(healthManager.todaySteps))",
                            unit: "steps",
                            icon: "figure.walk",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Calories",
                            value: "\(Int(healthManager.todayCalories + dataStore.getTodayCalories()))",
                            unit: "kcal",
                            icon: "flame.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Distance",
                            value: String(format: "%.1f", healthManager.todayDistance),
                            unit: "km",
                            icon: "location.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Heart Rate",
                            value: "\(Int(healthManager.heartRate))",
                            unit: "bpm",
                            icon: "heart.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)
                    
                    // Today's Activities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Activities")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if dataStore.getTodayWorkouts().isEmpty {
                            EmptyStateView(
                                icon: "figure.run",
                                message: "No workouts today",
                                actionText: "Add Workout"
                            )
                        } else {
                            ForEach(dataStore.getTodayWorkouts()) { workout in
                                WorkoutRowView(workout: workout)
                            }
                        }
                    }
                    .padding(.top)
                    
                    // Nutrition Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nutrition")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        NutritionSummaryView()
                            .environmentObject(dataStore)
                    }
                    .padding(.top)
                    
                    // Sleep Summary
                    if let lastSleep = dataStore.getLastSleepRecord() {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Last Night's Sleep")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            SleepSummaryCard(record: lastSleep)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .refreshable {
                healthManager.fetchTodayData()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.type.icon)
                .foregroundColor(.green)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.headline)
                Text("\(workout.duration) min • \(Int(workout.calories)) kcal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct NutritionSummaryView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        let todayMeals = dataStore.getTodayMeals()
        let totalCalories = dataStore.getTodayCalories()
        let goal = dataStore.userProfile.dailyCalorieGoal
        
        VStack(spacing: 12) {
            HStack {
                Text("Calories")
                    .font(.headline)
                Spacer()
                Text("\(Int(totalCalories)) / \(Int(goal))")
                    .font(.headline)
            }
            
            ProgressView(value: totalCalories, total: goal)
                .tint(.green)
            
            if !todayMeals.isEmpty {
                HStack {
                    Text("\(todayMeals.count) meals logged")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                Text("No meals logged today")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct SleepSummaryCard: View {
    let record: SleepRecord
    
    var body: some View {
        HStack {
            Image(systemName: "moon.fill")
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(String(format: "%.1f", record.duration)) hours")
                    .font(.headline)
                Text("Quality: \(record.quality.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct EmptyStateView: View {
    let icon: String
    let message: String
    let actionText: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    DashboardView()
        .environmentObject(HealthManager())
        .environmentObject(DataStore())
}

