import SwiftUI

struct FlightListView: View {
    @State private var flights: [FlightModel] = []
    @State private var adminPassword: String = "" // ✅ 관리자 비밀번호 입력 필드 추가
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                List(flights, id: \.id) { flight in
                    VStack(alignment: .leading) {
                        Text(flight.flightNumber)
                            .font(.headline)
                        Text("\(flight.departure) → \(flight.destination)")
                            .font(.subheadline)
                    }
                }
                
                // ✅ 관리자 비밀번호 입력 필드 추가
                SecureField("관리자 비밀번호 입력", text: $adminPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // ✅ 샘플 항공편 추가 버튼 수정
                Button("Add Sample Flight") {
                    let success = DatabaseService.shared.addFlight(
                        flightNumber: "101", // ✅ KE 자동 적용됨
                        departure: "ICN",
                        destination: "LAX",
                        adminPassword: adminPassword
                    )
                    if success {
                        alertMessage = "항공편이 성공적으로 추가되었습니다!"
                        flights = DatabaseService.shared.fetchFlights() // ✅ 데이터 새로고침
                    } else {
                        alertMessage = "항공편 추가 실패! 관리자 비밀번호를 확인하세요."
                    }
                    showAlert = true
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                }
            }
            .navigationTitle("Flights")
            .onAppear {
                flights = DatabaseService.shared.fetchFlights()
            }
        }
    }
}
