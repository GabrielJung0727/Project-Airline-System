//
//  WeatherModel.swift
//  project_airplane01
//
//  Created by Gabriel on 2/24/25.
//

import Foundation

// ✅ OpenWeather API 응답 모델
struct WeatherResponse: Codable {
    let name: String        // 도시(공항) 이름
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double        // 온도
    let humidity: Int       // 습도
}

struct Weather: Codable {
    let description: String // 날씨 설명
    let icon: String        // 날씨 아이콘 코드
}
