//
//  AdminDashboardView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/25/25.
//


import SwiftUI

struct AdminDashboardView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AdminFlightAddView()) {
                    Text("✈️ 항공편 추가")
                }
                NavigationLink(destination: CrewManagementView()) {
                Text("👨‍✈️ 승무원 관리")
                }
                NavigationLink(destination: PilotManagementView()) {
                     Text("👨‍✈️ 조종사 관리")
                 }
                 NavigationLink(destination: SearchLogsView()) {
                     Text("📜 검색 기록 확인")
                 }
            }
            .navigationTitle("관리자 패널")
        }
    }
}
