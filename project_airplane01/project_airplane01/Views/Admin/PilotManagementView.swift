//
//  PilotManagementView.swift
//  project_airplane01
//
//  Created by Gabriel on 2/25/25.
//

import SwiftUI

struct PilotManagementView: View {
    @State private var pilots: [PilotModel] = []
    @State private var newPilotName: String = ""
    @State private var newPilotID: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(pilots, id: \.id) { pilot in
                        HStack {
                            Text("\(pilot.name) (ID: \(pilot.id))")
                            Spacer()
                            Button(action: {
                                DatabaseService.shared.deletePilot(id: pilot.id)
                                pilots = DatabaseService.shared.fetchPilots()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Pilot Management")

                VStack {
                    TextField("Pilot Name", text: $newPilotName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Pilot ID", text: $newPilotID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Add Pilot") {
                        let success = DatabaseService.shared.addPilot(name: newPilotName, id: newPilotID)
                        if success {
                            pilots = DatabaseService.shared.fetchPilots()
                            alertMessage = "Pilot added successfully!"
                        } else {
                            alertMessage = "Failed to add pilot."
                        }
                        showAlert = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                pilots = DatabaseService.shared.fetchPilots()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
