//
//  project_airplane01App.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

@main
struct project_airplane01App: App {
    @StateObject private var userManager = UserManager() // ✅ 전역 UserManager 인스턴스 생성

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(userManager) // ✅ 모든 View에서 사용 가능하도록 설정
        }
    }
}
