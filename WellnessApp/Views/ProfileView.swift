//
//  ProfileView.swift
//  WellnessApp
//
//  User profile and settings view
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dataStore.userProfile.name.isEmpty ? "Your Name" : dataStore.userProfile.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(dataStore.userProfile.goal.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Personal Information") {
                    ProfileRow(title: "Age", value: "\(dataStore.userProfile.age) years")
                    ProfileRow(title: "Height", value: "\(Int(dataStore.userProfile.height)) cm")
                    ProfileRow(title: "Weight", value: "\(Int(dataStore.userProfile.weight)) kg")
                    
                    let bmi = dataStore.userProfile.weight / pow(dataStore.userProfile.height / 100, 2)
                    ProfileRow(title: "BMI", value: String(format: "%.1f", bmi))
                }
                
                Section("Goals") {
                    ProfileRow(title: "Daily Calorie Goal", value: "\(Int(dataStore.userProfile.dailyCalorieGoal)) kcal")
                    ProfileRow(title: "Daily Step Goal", value: "\(dataStore.userProfile.dailyStepGoal) steps")
                    ProfileRow(title: "Health Goal", value: dataStore.userProfile.goal.rawValue)
                }
                
                Section {
                    Button {
                        showingEditProfile = true
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit Profile")
                        }
                        .foregroundColor(.green)
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
                    .environmentObject(dataStore)
            }
        }
    }
}

struct ProfileRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: DataStore
    
    @State private var name: String = ""
    @State private var age: Int = 30
    @State private var height: Double = 170
    @State private var weight: Double = 70
    @State private var goal: HealthGoal = .maintain
    @State private var dailyCalorieGoal: Double = 2000
    @State private var dailyStepGoal: Int = 10000
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    Stepper("Age: \(age) years", value: $age, in: 1...120)
                    Stepper("Height: \(Int(height)) cm", value: $height, in: 100...250, step: 1)
                    Stepper("Weight: \(Int(weight)) kg", value: $weight, in: 30...200, step: 0.5)
                }
                
                Section("Goals") {
                    Picker("Health Goal", selection: $goal) {
                        ForEach(HealthGoal.allCases, id: \.self) { goal in
                            Text(goal.rawValue).tag(goal)
                        }
                    }
                    
                    Stepper("Daily Calorie Goal: \(Int(dailyCalorieGoal)) kcal", value: $dailyCalorieGoal, in: 1000...4000, step: 50)
                    Stepper("Daily Step Goal: \(dailyStepGoal) steps", value: $dailyStepGoal, in: 1000...50000, step: 500)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dataStore.userProfile.name = name
                        dataStore.userProfile.age = age
                        dataStore.userProfile.height = height
                        dataStore.userProfile.weight = weight
                        dataStore.userProfile.goal = goal
                        dataStore.userProfile.dailyCalorieGoal = dailyCalorieGoal
                        dataStore.userProfile.dailyStepGoal = dailyStepGoal
                        dataStore.saveProfile()
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            name = dataStore.userProfile.name
            age = dataStore.userProfile.age
            height = dataStore.userProfile.height
            weight = dataStore.userProfile.weight
            goal = dataStore.userProfile.goal
            dailyCalorieGoal = dataStore.userProfile.dailyCalorieGoal
            dailyStepGoal = dataStore.userProfile.dailyStepGoal
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(DataStore())
}

