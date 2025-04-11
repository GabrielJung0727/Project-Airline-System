//
//  WeatherView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherService = WeatherService() // ✅ @StateObject 유지
    @State private var city = "Seoul" // 기본 공항: 서울

    var body: some View {
        VStack {
            Text("🌍 Airport Weather")
                .font(.title2)
                .fontWeight(.bold)
                .padding()

            // 도시 선택
            Picker("Select Airport", selection: $city) {
                Text("Seoul (ICN)").tag("Seoul")
                Text("Tokyo (NRT)").tag("Tokyo")
                Text("London (LHR)").tag("London")
                Text("New York (JFK)").tag("New York")
                Text("Paris (CDG)").tag("Paris")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onChange(of: city) { oldCity, newCity in // ✅ 변경 감지 후 API 호출
                weatherService.fetchWeather(for: newCity)
            }

            // ✅ weatherService.weather 접근 방식 수정
            if let weather = weatherService.weather {
                VStack {
                    Text("\(weather.name)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    Text("🌡 \(String(format: "%.1f", weather.main.temp))°C")
                        .font(.title)
                        .padding()

                    Text("💧 Humidity: \(weather.main.humidity)%")
                        .font(.subheadline)

                    Text(weather.weather.first?.description.capitalized ?? "")
                        .font(.headline)
                        .padding()

                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png"))
                        .frame(width: 100, height: 100)
                }
                .padding()
            } else {
                Text("Fetching Weather...")
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .onAppear {
            weatherService.fetchWeather(for: city) // ✅ 화면 로딩 시 첫 API 호출
        }
    }
}
