//
//  WeatherService.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import Foundation

class WeatherService: ObservableObject {
    @Published var weather: WeatherResponse?

    private let apiKey = "YOUR_API_KEY" // OpenWeather API Key
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String) {
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weather = decodedResponse
                    }
                } catch {
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }
}
