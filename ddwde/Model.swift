//
//  Model.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/3/23.
//

import Foundation

struct Step: Identifiable{
    let id = UUID()
    let count: Int
    let date: Date
}

struct ActiveEnergy: Identifiable{
    let id = UUID()
    let count: Int
    let date: Date
}

struct FlightsClimbed: Identifiable{
    let id = UUID()
    let count: Int
    let date: Date
}

struct HeartRate: Identifiable{
    let id = UUID()
    let count: Int
    let date: Date
}
