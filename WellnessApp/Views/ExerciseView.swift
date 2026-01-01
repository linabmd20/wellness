//
//  ExerciseView.swift
//  WellnessApp
//
//  Workout tracking view
//

import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingAddWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Today's Workouts") {
                    if dataStore.getTodayWorkouts().isEmpty {
                        Text("No workouts logged today")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(dataStore.getTodayWorkouts()) { workout in
                            WorkoutDetailRow(workout: workout)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let workout = dataStore.getTodayWorkouts()[index]
                                dataStore.deleteWorkout(workout)
                            }
                        }
                    }
                }
                
                Section("Recent Workouts") {
                    let recentWorkouts = dataStore.workouts.sorted { $0.date > $1.date }.prefix(10)
                    if recentWorkouts.isEmpty {
                        Text("No workouts yet")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(Array(recentWorkouts)) { workout in
                            WorkoutDetailRow(workout: workout)
                        }
                    }
                }
            }
            .navigationTitle("Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddWorkout = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
                    .environmentObject(dataStore)
            }
        }
    }
}

struct WorkoutDetailRow: View {
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
                
                HStack {
                    Label("\(workout.duration)", systemImage: "clock")
                    Text("•")
                    Label("\(Int(workout.calories))", systemImage: "flame.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Text(workout.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: DataStore
    
    @State private var workoutName = ""
    @State private var selectedType = WorkoutType.running
    @State private var duration = 30
    @State private var calories = 200.0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Workout Details") {
                    TextField("Workout Name", text: $workoutName)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    
                    Stepper("Duration: \(duration) minutes", value: $duration, in: 1...300)
                    
                    Stepper("Calories: \(Int(calories)) kcal", value: $calories, in: 0...2000, step: 10)
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let workout = Workout(
                            name: workoutName.isEmpty ? selectedType.rawValue : workoutName,
                            duration: duration,
                            calories: calories,
                            type: selectedType
                        )
                        dataStore.addWorkout(workout)
                        dismiss()
                    }
                    .disabled(workoutName.isEmpty && selectedType == .other)
                }
            }
        }
    }
}

#Preview {
    ExerciseView()
        .environmentObject(DataStore())
}

