//
//  ContentView.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/3/23.
//

import SwiftUI
import HealthKit

struct steps: View {
    private var healthStore: Healthstore?
    @State private var steps: [Step] = [Step]()
    init(){
        healthStore = Healthstore()
    }
    
    private func updateUIformstats(_ statisticsCollections: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate  = Date()
        steps.removeAll()
        statisticsCollections.enumerateStatistics(from: startDate, to: endDate) {
            (statistics,
             stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
    }
    
    var body: some View {
        NavigationView {
            
            List(steps, id: \.id) { step in
                VStack(alignment: .leading){
                    Text("\(step.count) steps")
                    Text((step.date), style: .date)
                        .opacity(0.5)
                }
            }
            .navigationTitle("Steps")
        }
        .onAppear{
            if let healthStore = healthStore{
                healthStore.requestAuthorization{
                    success in
                    if success{
                        healthStore.calculateSteps {
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
}

struct steps_Previews: PreviewProvider {
    static var previews: some View {
       steps()
    }
}
