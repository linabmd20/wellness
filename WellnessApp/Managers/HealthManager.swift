//
//  HealthManager.swift
//  WellnessApp
//
//  Manages health data and calculations
//

import Foundation
import HealthKit
import Combine

class HealthManager: ObservableObject {
    @Published var todaySteps: Double = 0
    @Published var todayCalories: Double = 0
    @Published var todayDistance: Double = 0
    @Published var heartRate: Double = 0
    @Published var isAuthorized = false
    
    private let healthStore = HKHealthStore()
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.fetchTodayData()
                }
            }
        }
    }
    
    func fetchTodayData() {
        fetchSteps()
        fetchCalories()
        fetchDistance()
        fetchHeartRate()
    }
    
    private func fetchSteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            DispatchQueue.main.async {
                self?.todaySteps = sum.doubleValue(for: HKUnit.count())
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchCalories() {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            DispatchQueue.main.async {
                self?.todayCalories = sum.doubleValue(for: HKUnit.kilocalorie())
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchDistance() {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            DispatchQueue.main.async {
                self?.todayDistance = sum.doubleValue(for: HKUnit.meterUnit(with: .kilo))
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchHeartRate() {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else {
                return
            }
            DispatchQueue.main.async {
                self?.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }
        
        healthStore.execute(query)
    }
}

