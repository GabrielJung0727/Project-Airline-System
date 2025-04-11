//
//  CrewDashboardView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

struct CrewDashboardView: View {
    @State private var flightList: [FlightModel] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("🛫 Crew Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                List(flightList, id: \.id) { flight in
                    VStack(alignment: .leading) {
                        Text("✈️ \(flight.flightNumber)")
                            .font(.headline)
                        Text("\(flight.departure) → \(flight.destination)")
                            .font(.subheadline)
                    }
                }
                .onAppear {
                    flightList = DatabaseService.shared.fetchFlights()
                }
            }
            .navigationTitle("승무원")
        }
    }
}
