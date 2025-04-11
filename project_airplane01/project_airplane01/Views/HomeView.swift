//
//  HomeView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/23/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager // ✅ EnvironmentObject로 UserManager 사용

    var body: some View {
        VStack {
            Text("Welcome, \(userManager.username)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.blue)

            Image(systemName: "hand.wave.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
        }
    }
}
