import SwiftUI

struct CrewManagementView: View {
    @State private var crewMembers: [CrewModel] = []
    @State private var newCrewName: String = ""
    @State private var newCrewID: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(crewMembers, id: \.id) { crew in
                        HStack {
                            Text("\(crew.name) (ID: \(crew.id))")
                            Spacer()
                            Button(action: {
                                DatabaseService.shared.deleteCrewMember(id: crew.id)
                                crewMembers = DatabaseService.shared.fetchCrewMembers()
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Crew Management")

                VStack {
                    TextField("Crew Name", text: $newCrewName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Crew ID", text: $newCrewID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Add Crew Member") {
                        let success = DatabaseService.shared.addCrewMember(name: newCrewName, id: newCrewID)
                        if success {
                            crewMembers = DatabaseService.shared.fetchCrewMembers()
                            alertMessage = "Crew member added successfully!"
                        } else {
                            alertMessage = "Failed to add crew member."
                        }
                        showAlert = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                crewMembers = DatabaseService.shared.fetchCrewMembers()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
