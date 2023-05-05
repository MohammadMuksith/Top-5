//
//  weee.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/4/23.
//

import SwiftUI
import HealthKit

struct flightsClimbed: View {
    private var healthStore: Healthstore?
    @State private var flights: [FlightsClimbed] = [FlightsClimbed]()
    init(){
        healthStore = Healthstore()
    }

    private func updateUIformstats(_ statisticsCollections: HKStatisticsCollection){
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate  = Date()
        
        flights.removeAll()
        
        statisticsCollections.enumerateStatistics(from: startDate, to: endDate) {
            (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let flight = FlightsClimbed(count: Int(count ?? 0), date: statistics.startDate)
            flights.append(flight)
        }
    }

    
    var body: some View {
        NavigationView {
            
            List(flights, id: \.id) { flight in
                VStack(alignment: .leading){
                    Text("\(flight.count) flights climbed")
                    Text((flight.date), style: .date)
                        .opacity(0.5)
                }
            }
            .navigationTitle("Flights Climbed")
        }
        .onAppear{
            if let healthStore = healthStore{
                healthStore.requestAuthorization{
                    success in
                    if success{
                        healthStore.calculateflightsClimbed {
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

struct flightsClimbed_Previews: PreviewProvider {
    static var previews: some View {
        flightsClimbed()
    }
}
