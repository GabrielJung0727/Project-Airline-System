import SwiftUI

struct LoginView: View {
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var userManager: UserManager // ✅ EnvironmentObject 사용

    var body: some View {
        VStack {
            Text("🔑 User Login")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("User ID", text: $userID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                if let (role, username) = DatabaseService.shared.loginUser(userID: userID, password: password) {
                    userManager.userRole = role // ✅ 역할(role) 저장
                    userManager.username = username // ✅ 사용자명(username) 저장
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
