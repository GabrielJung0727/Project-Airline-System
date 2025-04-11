//
//  TabBarView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/24/25.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var userManager = UserManager() // ✅ 사용자 역할을 관리하는 객체

    var body: some View {
        TabView {
            if userManager.userRole == "default" {
                // ✅ 로그인 전에는 로그인 탭만 표시
                AdminLoginView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Admin Login")
                    }

                CrewLoginView()
                    .tabItem {
                        Image(systemName: "person.fill.badge.plus")
                        Text("Crew Login")
                    }

                PilotLoginView() // ✅ PilotLoginView 추가
                    .tabItem {
                        Image(systemName: "airplane.circle.fill")
                        Text("Pilot Login")
                    }
            } else {
                // ✅ 로그인 후 탭 표시
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                FlightListView()
                    .tabItem {
                        Image(systemName: "airplane")
                        Text("Flights")
                    }

                SeatMapView()
                    .tabItem {
                        Image(systemName: "seat")
                        Text("Seats")
                    }

                WeatherView()
                    .tabItem {
                        Image(systemName: "cloud.sun.fill")
                        Text("Weather")
                    }

                // ✅ 사용자의 역할(Role)에 따라 다르게 표시
                if userManager.userRole == "crew" {
                    CrewDashboardView()
                        .tabItem {
                            Image(systemName: "person.fill.badge.plus")
                            Text("Crew")
                        }
                } else if userManager.userRole == "pilot" {
                    PilotDashboardView()
                        .tabItem {
                            Image(systemName: "airplane.circle.fill")
                            Text("Pilot")
                        }
                } else if userManager.userRole == "admin" {
                    AdminDashboardView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("Admin")
                        }
                }
            }
        }
        .onAppear {
            userManager.fetchUserRole() // ✅ 사용자 역할 가져오기
        }
    }
}
