//
//  HealthData.swift
//  WellnessApp
//
//  Data models for health tracking
//

import Foundation

struct HealthMetric: Identifiable, Codable {
    let id: UUID
    var date: Date
    var value: Double
    var type: HealthMetricType
    
    init(id: UUID = UUID(), date: Date = Date(), value: Double, type: HealthMetricType) {
        self.id = id
        self.date = date
        self.value = value
        self.type = type
    }
}

enum HealthMetricType: String, Codable, CaseIterable {
    case steps = "Steps"
    case heartRate = "Heart Rate"
    case calories = "Calories"
    case distance = "Distance"
    case activeMinutes = "Active Minutes"
    
    var unit: String {
        switch self {
        case .steps: return "steps"
        case .heartRate: return "bpm"
        case .calories: return "kcal"
        case .distance: return "km"
        case .activeMinutes: return "min"
        }
    }
    
    var icon: String {
        switch self {
        case .steps: return "figure.walk"
        case .heartRate: return "heart.fill"
        case .calories: return "flame.fill"
        case .distance: return "location.fill"
        case .activeMinutes: return "clock.fill"
        }
    }
}

struct Workout: Identifiable, Codable {
    let id: UUID
    var name: String
    var duration: Int // minutes
    var calories: Double
    var date: Date
    var type: WorkoutType
    
    init(id: UUID = UUID(), name: String, duration: Int, calories: Double, date: Date = Date(), type: WorkoutType) {
        self.id = id
        self.name = name
        self.duration = duration
        self.calories = calories
        self.date = date
        self.type = type
    }
}

enum WorkoutType: String, Codable, CaseIterable {
    case running = "Running"
    case walking = "Walking"
    case cycling = "Cycling"
    case yoga = "Yoga"
    case strength = "Strength Training"
    case swimming = "Swimming"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .running: return "figure.run"
        case .walking: return "figure.walk"
        case .cycling: return "bicycle"
        case .yoga: return "figure.flexibility"
        case .strength: return "dumbbell.fill"
        case .swimming: return "figure.pool.swim"
        case .other: return "figure.mixed.cardio"
        }
    }
}

struct Meal: Identifiable, Codable {
    let id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var date: Date
    var mealType: MealType
    
    init(id: UUID = UUID(), name: String, calories: Double, protein: Double, carbs: Double, fat: Double, date: Date = Date(), mealType: MealType) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.date = date
        self.mealType = mealType
    }
}

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "sunset.fill"
        case .snack: return "leaf.fill"
        }
    }
}

struct SleepRecord: Identifiable, Codable {
    let id: UUID
    var date: Date
    var sleepTime: Date
    var wakeTime: Date
    var duration: Double // hours
    var quality: SleepQuality
    
    init(id: UUID = UUID(), date: Date = Date(), sleepTime: Date, wakeTime: Date, quality: SleepQuality) {
        self.id = id
        self.date = date
        self.sleepTime = sleepTime
        self.wakeTime = wakeTime
        self.quality = quality
        self.duration = Calendar.current.dateComponents([.hour, .minute], from: sleepTime, to: wakeTime).hour ?? 0
    }
}

enum SleepQuality: String, Codable, CaseIterable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "blue"
        case .fair: return "orange"
        case .poor: return "red"
        }
    }
}

struct UserProfile: Codable {
    var name: String
    var age: Int
    var height: Double // cm
    var weight: Double // kg
    var goal: HealthGoal
    var dailyCalorieGoal: Double
    var dailyStepGoal: Int
    
    init(name: String = "", age: Int = 30, height: Double = 170, weight: Double = 70, goal: HealthGoal = .maintain, dailyCalorieGoal: Double = 2000, dailyStepGoal: Int = 10000) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.goal = goal
        self.dailyCalorieGoal = dailyCalorieGoal
        self.dailyStepGoal = dailyStepGoal
    }
}

enum HealthGoal: String, Codable, CaseIterable {
    case loseWeight = "Lose Weight"
    case maintain = "Maintain Weight"
    case gainWeight = "Gain Weight"
    case buildMuscle = "Build Muscle"
    case improveFitness = "Improve Fitness"
}

