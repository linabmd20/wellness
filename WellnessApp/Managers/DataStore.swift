//
//  DataStore.swift
//  WellnessApp
//
//  Manages app data storage
//

import Foundation
import Combine

class DataStore: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var meals: [Meal] = []
    @Published var sleepRecords: [SleepRecord] = []
    @Published var healthMetrics: [HealthMetric] = []
    @Published var userProfile: UserProfile = UserProfile()
    
    private let workoutsKey = "SavedWorkouts"
    private let mealsKey = "SavedMeals"
    private let sleepKey = "SavedSleep"
    private let profileKey = "UserProfile"
    
    init() {
        loadData()
    }
    
    // MARK: - Workouts
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveWorkouts()
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts()
    }
    
    func getTodayWorkouts() -> [Workout] {
        let today = Calendar.current.startOfDay(for: Date())
        return workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    // MARK: - Meals
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        saveMeals()
    }
    
    func deleteMeal(_ meal: Meal) {
        meals.removeAll { $0.id == meal.id }
        saveMeals()
    }
    
    func getTodayMeals() -> [Meal] {
        let today = Calendar.current.startOfDay(for: Date())
        return meals.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func getTodayCalories() -> Double {
        return getTodayMeals().reduce(0) { $0 + $1.calories }
    }
    
    // MARK: - Sleep
    func addSleepRecord(_ record: SleepRecord) {
        sleepRecords.append(record)
        saveSleep()
    }
    
    func deleteSleepRecord(_ record: SleepRecord) {
        sleepRecords.removeAll { $0.id == record.id }
        saveSleep()
    }
    
    func getLastSleepRecord() -> SleepRecord? {
        return sleepRecords.sorted { $0.date > $1.date }.first
    }
    
    // MARK: - Persistence
    private func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
        }
    }
    
    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: mealsKey)
        }
    }
    
    private func saveSleep() {
        if let encoded = try? JSONEncoder().encode(sleepRecords) {
            UserDefaults.standard.set(encoded, forKey: sleepKey)
        }
    }
    
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: workoutsKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: mealsKey),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            meals = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: sleepKey),
           let decoded = try? JSONDecoder().decode([SleepRecord].self, from: data) {
            sleepRecords = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
}

