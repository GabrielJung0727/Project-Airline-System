//
//  SeatMapView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

struct SeatMapView: View {
    let businessRows = 4 // 비즈니스 클래스 4줄
    let economyRows = 30 // 이코노미 클래스 30줄
    let businessColumns = ["A", "B", "D", "E"] // 2-2 배열
    let economyColumns = ["A", "B", "C", "D", "E", "F"] // 3-3 배열
    
    @State private var selectedSeats: Set<String> = [] // 선택한 좌석 저장

    var body: some View {
        VStack {
            Text("🛫 A321-neo Seat Selection")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            ScrollView {
                LazyVStack(spacing: 5) {
                    
                    // ✅ 비즈니스 클래스 (2-2 배열)
                    ForEach(1...businessRows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(businessColumns, id: \.self) { column in
                                let seatID = "\(column)\(row)"
                                SeatButton(seatID: seatID, selectedSeats: $selectedSeats, color: .blue)
                            }
                        }
                    }
                    
                    Text("Economy Class")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    // ✅ 이코노미 클래스 (3-3 배열)
                    ForEach(5...(4 + economyRows), id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(economyColumns, id: \.self) { column in
                                let seatID = "\(column)\(row)"
                                let seatColor: Color = getSeatColor(row: row, column: column)
                                SeatButton(seatID: seatID, selectedSeats: $selectedSeats, color: seatColor)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Text("Selected Seats: \(selectedSeats.joined(separator: ", "))")
                .font(.footnote)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Seat Map")
    }
    
    // ✅ 좌석 색상 지정 (출구석, 일반석, 장애인석)
    func getSeatColor(row: Int, column: String) -> Color {
        if row == 38 { return .green } // 비상구 좌석
        if row == 31 || row == 56 { return .purple } // 장애인 좌석
        return .gray.opacity(0.3) // 일반 좌석
    }
}

// ✅ 좌석 버튼 구성 (클릭 가능)
struct SeatButton: View {
    let seatID: String
    @Binding var selectedSeats: Set<String>
    let color: Color
    
    var body: some View {
        Button(action: {
            toggleSeatSelection()
        }) {
            Text(seatID)
                .frame(width: 40, height: 40)
                .background(selectedSeats.contains(seatID) ? Color.green : color)
                .cornerRadius(8)
                .foregroundColor(.black)
        }
    }
    
    func toggleSeatSelection() {
        if selectedSeats.contains(seatID) {
            selectedSeats.remove(seatID)
        } else {
            selectedSeats.insert(seatID)
        }
    }
}
