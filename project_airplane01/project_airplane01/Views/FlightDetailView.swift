//
//  FlightDetailView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

struct FlightDetailView: View {
    var flight: String

    var body: some View {
        VStack {
            Text(flight)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("🛫 Departure: 10:00 AM")
            Text("🛬 Arrival: 2:00 PM")
            Text("⏳ Duration: 4 hours")

            Spacer()
        }
        .navigationTitle("Flight Details")
    }
}
