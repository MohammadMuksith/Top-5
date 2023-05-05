//
//  SwiftUIView.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/3/23.
//

import SwiftUI
import HealthKit

struct activeEnergyBurned: View {
    private var healthStore: Healthstore?
    @State private var activeEnergy: [ActiveEnergy] = [ActiveEnergy]()
    init(){
        healthStore = Healthstore()
    }
    
    private func updateUIformstats(_ statisticsCollections: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate  = Date()
        activeEnergy.removeAll()
        statisticsCollections.enumerateStatistics(from: startDate, to: endDate) {
            (statistics,
             stop) in
        
            let activecount = statistics.sumQuantity()?.doubleValue(for: .largeCalorie())
            
            let active = ActiveEnergy(count: Int(activecount ?? 0), date: statistics.startDate)
            activeEnergy.append(active)
        }
    }
    
    var body: some View {
        NavigationView {
            
            List(activeEnergy, id: \.id) { energy in
                VStack(alignment: .leading){
                    Text("\(energy.count) calories")
                    Text((energy.date), style: .date)
                        .opacity(0.5)
                }
           }
           
            .navigationTitle("Calories Burned")
        }
        .onAppear{
//            if let healthStore = healthStore{
//                healthStore.requestAuthorization{
//                    success in
//                    if success{
//                        healthStore.calculateActiveEnergy {
//                            statisticsCollection in
//                            if let statisticsCollection = statisticsCollection{
//                                updateUIformstats(statisticsCollection)
//                            }
//                        }
//                    }
//                }
//            }
            onAppea()
        }
    }
    func onAppea(){
        if let healthStore = healthStore{
            healthStore.requestAuthorization{
                success in
                if success{
                    healthStore.calculateActiveEnergy {
                        statisticsCollection in
                        if let statisticsCollection = statisticsCollection{
                            updateUIformstats(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
}

struct activeEnergyBurned_Previews: PreviewProvider {
    static var previews: some View {
        activeEnergyBurned()
    }
}
