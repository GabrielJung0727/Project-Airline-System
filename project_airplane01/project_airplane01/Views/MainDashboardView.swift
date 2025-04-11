import SwiftUI

struct MainDashboardView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        VStack {
            Text("User Role: \(userManager.userRole)") // ✅ userRole 표시
                .font(.title)
                .bold()
                .padding()

            if userManager.userRole == "admin" {
                AdminDashboardView()
                
                Divider().padding()

                // ✅ 관리자 추가 기능 (승무원/조종사 관리 및 로그 조회)
                NavigationView {
                    List {
                        NavigationLink(destination: CrewManagementView()) {
                            Label("Manage Crew Members", systemImage: "person.3.fill")
                        }

                        NavigationLink(destination: PilotManagementView()) {
                            Label("Manage Pilots", systemImage: "airplane.circle.fill")
                        }

                        NavigationLink(destination: SearchLogsView()) {
                            Label("View Activity Logs", systemImage: "doc.text.magnifyingglass")
                        }
                    }
                    .navigationTitle("Admin Management")
                }
            } else if userManager.userRole == "crew" {
                CrewDashboardView()
            } else if userManager.userRole == "pilot" {
                PilotDashboardView()
            } else {
                Text("Please log in to access the dashboard.")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear {
            userManager.fetchUserRole() // ✅ 역할 가져오기
        }
    }
}
