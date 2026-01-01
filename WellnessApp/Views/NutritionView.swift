//
//  NutritionView.swift
//
//  Meal and nutrition tracking view
//

import SwiftUI

struct NutritionView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingAddMeal = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Today's Summary") {
                    NutritionSummaryRow(
                        title: "Total Calories",
                        value: "\(Int(dataStore.getTodayCalories()))",
                        goal: dataStore.userProfile.dailyCalorieGoal
                    )
                    
                    let todayMeals = dataStore.getTodayMeals()
                    let totalProtein = todayMeals.reduce(0) { $0 + $1.protein }
                    let totalCarbs = todayMeals.reduce(0) { $0 + $1.carbs }
                    let totalFat = todayMeals.reduce(0) { $0 + $1.fat }
                    
                    NutritionMacroRow(title: "Protein", value: totalProtein, unit: "g", color: .blue)
                    NutritionMacroRow(title: "Carbs", value: totalCarbs, unit: "g", color: .orange)
                    NutritionMacroRow(title: "Fat", value: totalFat, unit: "g", color: .green)
                }
                
                Section("Today's Meals") {
                    if dataStore.getTodayMeals().isEmpty {
                        Text("No meals logged today")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(dataStore.getTodayMeals()) { meal in
                            MealRow(meal: meal)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let meal = dataStore.getTodayMeals()[index]
                                dataStore.deleteMeal(meal)
                            }
                        }
                    }
                }
                
                Section("Recent Meals") {
                    let recentMeals = dataStore.meals.sorted { $0.date > $1.date }.prefix(10)
                    if recentMeals.isEmpty {
                        Text("No meals yet")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(Array(recentMeals)) { meal in
                            MealRow(meal: meal)
                        }
                    }
                }
            }
            .navigationTitle("Nutrition")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView()
                    .environmentObject(dataStore)
            }
        }
    }
}

struct NutritionSummaryRow: View {
    let title: String
    let value: String
    let goal: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(value) / \(Int(goal)) kcal")
                    .font(.subheadline)
            }
            
            ProgressView(value: Double(value) ?? 0, total: goal)
                .tint(.green)
        }
        .padding(.vertical, 4)
    }
}

struct NutritionMacroRow: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(Int(value)) \(unit)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct MealRow: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: meal.mealType.icon)
                    .foregroundColor(.green)
                
                Text(meal.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(meal.calories)) kcal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                Label("\(Int(meal.protein))g", systemImage: "p.circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Label("\(Int(meal.carbs))g", systemImage: "c.circle.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Label("\(Int(meal.fat))g", systemImage: "f.circle.fill")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Text(meal.date, style: .time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: DataStore
    
    @State private var mealName = ""
    @State private var selectedMealType = MealType.breakfast
    @State private var calories = 300.0
    @State private var protein = 20.0
    @State private var carbs = 40.0
    @State private var fat = 10.0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Meal Details") {
                    TextField("Meal Name", text: $mealName)
                    
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(MealType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                }
                
                Section("Nutrition") {
                    Stepper("Calories: \(Int(calories)) kcal", value: $calories, in: 0...2000, step: 10)
                    Stepper("Protein: \(Int(protein)) g", value: $protein, in: 0...200, step: 1)
                    Stepper("Carbs: \(Int(carbs)) g", value: $carbs, in: 0...300, step: 1)
                    Stepper("Fat: \(Int(fat)) g", value: $fat, in: 0...100, step: 1)
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let meal = Meal(
                            name: mealName.isEmpty ? selectedMealType.rawValue : mealName,
                            calories: calories,
                            protein: protein,
                            carbs: carbs,
                            fat: fat,
                            mealType: selectedMealType
                        )
                        dataStore.addMeal(meal)
                        dismiss()
                    }
                    .disabled(mealName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NutritionView()
        .environmentObject(DataStore())
}

