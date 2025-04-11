import SwiftUI

struct CrewLoginView: View {
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        VStack {
            Text("👨‍✈️ Crew Login")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("Crew ID", text: $userID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)         // 추가
                .disableAutocorrection(true)          // 추가
                .padding()

            Button(action: {
                if let (role, username) = DatabaseService.shared.loginUser(userID: userID, password: password), role == "crew" {
                    userManager.userRole = role
                    userManager.username = username
                } else {
                    alertMessage = "Login failed! Please check your credentials."
                    showAlert = true
                }
            }) {
                Text("Login")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}
