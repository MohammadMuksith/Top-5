//
//  MainScreen.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/4/23.
//

import SwiftUI

struct MainScreen: View {
    init(){
        UITabBar.appearance().backgroundColor = UIColor(Color(.white))
    }
    
    
    var body: some View {
        TabView {
            steps()
                .tabItem {
                    Label("My Progress", systemImage: "chart.pie")
                }
            activeEnergyBurned()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            flightsClimbed()
                 .tabItem {
                     Label("Map", systemImage: "map")
                 }
            heartRate()
                 .tabItem {
                     Label("Map", systemImage: "map")
                 }
            CustomView()
                 .tabItem {
                     Label("Map", systemImage: "map")
                 }
            
           
                
            
            
        }
        .accentColor(Color(.green))
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
