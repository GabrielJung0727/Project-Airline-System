import SwiftUI

struct AdminFlightAddView: View {
    @State private var flightNumber: String = ""
    @State private var departure: String = "ICN" // 기본값 인천공항
    @State private var destination: String = ""
    @State private var adminPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    let destinations = ["LAX", "JFK", "HND", "NRT", "CDG", "LHR", "BKK", "SYD", "FRA"] // 대한항공 주요 노선

    var body: some View {
        VStack {
            Text("✈️ 대한항공 항공편 추가")
                .font(.largeTitle)
                .bold()
                .padding()

            HStack {
                Text("KE")
                    .font(.title)
                    .bold()
                TextField("항공편 번호 (예: 101)", text: $flightNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            Text("출발 공항: 인천(ICN)")
                .font(.headline)
                .padding()

            Picker("도착 공항", selection: $destination) {
                ForEach(destinations, id: \.self) { airport in
                    Text(airport)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            SecureField("관리자 비밀번호 입력", text: $adminPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                let success = DatabaseService.shared.addFlight(
                    flightNumber: flightNumber,
                    departure: departure,
                    destination: destination,
                    adminPassword: adminPassword
                )
                alertMessage = success ? "항공편이 추가되었습니다!" : "항공편 추가 실패! 관리자 비밀번호 확인 필요"
                showAlert = true
            }) {
                Text("항공편 추가")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
        .padding()
    }
}
