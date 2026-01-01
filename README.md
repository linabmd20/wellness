# Wellness App

A comprehensive iOS wellness tracking application built with SwiftUI.

## Features

### 🏃 Dashboard
- Overview of daily health metrics
- Quick stats for steps, calories, distance, and heart rate
- Today's activities summary
- Nutrition and sleep summaries

### ❤️ Health Tracking
- Real-time step count
- Calories burned tracking
- Distance tracking
- Heart rate monitoring
- Health tips and recommendations

### 💪 Exercise
- Log workouts with different types (Running, Walking, Cycling, Yoga, Strength Training, Swimming)
- Track workout duration and calories
- View workout history
- Today's workout summary

### 🍎 Nutrition
- Log meals with detailed nutrition information
- Track calories, protein, carbs, and fat
- Daily calorie goal tracking
- Meal history

### 😴 Sleep
- Record sleep duration and quality
- Track bedtime and wake time
- Sleep history
- Sleep quality ratings (Excellent, Good, Fair, Poor)
- Sleep tips

### 👤 Profile
- Personal information management
- Health goals setting
- BMI calculation
- Daily calorie and step goals

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## HealthKit Integration

The app integrates with Apple HealthKit to:
- Read step count, calories, distance, and heart rate
- Display real-time health metrics
- Sync with Apple Health app

## Setup Instructions

1. Open `WellnessApp.xcodeproj` in Xcode
2. Select your development team in Signing & Capabilities
3. Enable HealthKit capability in the project settings
4. Build and run on a device or simulator (HealthKit requires a physical device for full functionality)

## Architecture

- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Separation of concerns with ViewModels
- **HealthKit**: Integration with Apple's health framework
- **UserDefaults**: Local data persistence
- **Combine**: Reactive programming for data updates

## Data Models

- `HealthMetric`: Tracks various health metrics
- `Workout`: Exercise session information
- `Meal`: Nutrition and meal tracking
- `SleepRecord`: Sleep duration and quality
- `UserProfile`: User personal information and goals

## Future Enhancements

- Cloud sync with iCloud
- Social features and sharing
- Advanced analytics and charts
- Workout plans and recommendations
- Meal planning and recipes
- Integration with fitness wearables

## License

This project is created for educational purposes.

