//
//  HealthStore.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/3/23.
//

import Foundation
import HealthKit


extension Date{
    static func mondayAt12AM() -> Date{
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
class Healthstore{
    
    var healthstore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init(){
        if HKHealthStore.isHealthDataAvailable(){
            healthstore = HKHealthStore()
        }
    }
    func calculateSteps(completion: @escaping(HKStatisticsCollection?)-> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum , anchorDate: anchorDate, intervalComponents: daily)
        query!.initialResultsHandler = {
            query, statisticsCollection, error in completion(statisticsCollection)
        }
        if let healthstore = healthstore, let query = self.query{
            healthstore.execute(query)
        }
        
    }
    func calculateActiveEnergy(completion: @escaping(HKStatisticsCollection?)-> Void){
        let activeEnergyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum , anchorDate: anchorDate, intervalComponents: daily)
        query!.initialResultsHandler = {
            query, statisticsCollection, error in completion(statisticsCollection)
        }
        if let healthstore = healthstore, let query = self.query{
            healthstore.execute(query)
        }
        
    }
    func calculateflightsClimbed(completion: @escaping(HKStatisticsCollection?)-> Void){
        let flightsClimbedType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: flightsClimbedType, quantitySamplePredicate: predicate, options: .cumulativeSum , anchorDate: anchorDate, intervalComponents: daily)
        query!.initialResultsHandler = {
            query, statisticsCollection, error in completion(statisticsCollection)
        }
        if let healthstore = healthstore, let query = self.query{
            healthstore.execute(query)
        }
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void){
        let stepType: Set = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: .basalBodyTemperature)!, HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .flightsClimbed)!, HKObjectType.quantityType(forIdentifier: .walkingSpeed)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!]
        guard let healthstore = self.healthstore else{
            return completion(false)
        }
        healthstore.requestAuthorization(toShare: [], read: stepType) {(success, error) in
            completion(success)
            
        }
    }
}
