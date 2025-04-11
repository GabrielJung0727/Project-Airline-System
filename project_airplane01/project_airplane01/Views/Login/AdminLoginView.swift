import SwiftUI

struct AdminLoginView: View {
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        VStack {
            Text("🔑 Admin Login")
                .font(.largeTitle)
                .bold()
                .padding()

            TextField("Admin ID", text: $userID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textContentType(.password)      // 비밀번호 유형 지정
                .disableAutocorrection(true)       // 자동 수정 기능 끄기
                .padding()

            Button(action: {
                if let (role, username) = DatabaseService.shared.loginUser(userID: userID, password: password), role == "admin" {
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
