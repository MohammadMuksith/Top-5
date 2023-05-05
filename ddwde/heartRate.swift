//
//  heartRate.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/4/23.
//

import SwiftUI
import HealthKit

struct heartRate: View {
    private var healthStore: HealthStore?
    @State private var heartRates: [HeartRateData] = [HeartRateData]()
    
    init() {
        healthStore = HealthStore()
    }
    
    private func updateUIformstats(_ statisticsCollection: HKStatisticsCollection) {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        heartRates.removeAll()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.averageQuantity()?.doubleValue(for: .beatsPerMinute)
            let heartRateData = HeartRateData(count: Int(count ?? 0), date: statistics.startDate)
            heartRates.append(heartRateData)
        }
    }
    
    var body: some View {
        NavigationView {
            List(heartRates, id: \.id) { heartRate in
                VStack(alignment: .leading) {
                    Text("\(heartRate.count) bpm")
                    Text((heartRate.date), style: .date)
                        .opacity(0.5)
                }
            }
            .navigationTitle("Heart Rate")
        }
        .onAppear {
            if let healthStore = healthStore {
                healthStore.requestAuthorization { success in
                    if success {
                        healthStore.calculateHeartRate { statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                updateUIformstats(statisticsCollection)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HeartRateData {
    let count: Int
    let date: Date
    let id = UUID()
}

struct heartRate_Previews: PreviewProvider {
    static var previews: some View {
        heartRate()
    }
}


import Foundation
import HealthKit

extension HKUnit {
    static let beatsPerMinute = HKUnit.count().unitDivided(by: HKUnit.minute())
}

class HealthStore {
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = healthStore else {
            completion(false)
            return
        }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
            completion(success)
        }
    }
    
    func calculateHeartRate(completion: @escaping (HKStatisticsCollection?) -> Void) {
        guard let healthStore = healthStore else {
            completion(nil)
            return
        }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let datePredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let statisticsOptions = HKStatisticsOptions.discreteAverage
        
        let query = HKStatisticsCollectionQuery(
            quantityType: heartRateType,
            quantitySamplePredicate: datePredicate,
            options: statisticsOptions,
            anchorDate: Date.distantPast,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { query, results, error in
            completion(results)
        }
        
        healthStore.execute(query)
    }
}

