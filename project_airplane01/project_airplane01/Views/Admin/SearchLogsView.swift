//
//  SearchLogsView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/25/25.
//

import SwiftUI

struct SearchLogsView: View {
    @State private var logs: [LogModel] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(logs, id: \.id) { log in
                    VStack(alignment: .leading) {
                        Text("User: \(log.userID)")
                            .font(.headline)
                        Text("Action: \(log.action)")
                            .font(.subheadline)
                        Text("Date: \(log.timestamp)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
            .navigationTitle("Search & Activity Logs")
            .onAppear {
                logs = DatabaseService.shared.fetchLogs()
            }
        }
    }
}
