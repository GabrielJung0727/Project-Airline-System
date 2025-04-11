//
//  PilotDashboardView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

struct PilotDashboardView: View {
    @State private var flightList: [FlightModel] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("👨‍✈️ 조종사 대시보드")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                List(flightList, id: \.id) { flight in
                    VStack(alignment: .leading) {
                        Text("✈️ \(flight.flightNumber)")
                            .font(.headline)
                        Text("출발지: \(flight.departure)")
                        Text("도착지: \(flight.destination)")
                        Text("출발 시간: \(formattedDate(flight.departureTime))")
                        Text("도착 시간: \(formattedDate(flight.arrivalTime))")
                    }
                }
                .onAppear {
                    flightList = DatabaseService.shared.fetchFlights()
                }
            }
            .navigationTitle("조종사")
        }
    }
    
    // ✅ 날짜 포맷 함수
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}
