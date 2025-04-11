//
//  UserManager.swift
//  project_airplane01
//
//  Created by Gabriel on 2/25/25.
//

import Foundation

class UserManager: ObservableObject {
    @Published var userRole: String = "default"
    @Published var username: String = ""

    func fetchUserRole() {
        DispatchQueue.global(qos: .background).async {
            let role = DatabaseService.shared.getCurrentUserRole()
            DispatchQueue.main.async {
                if self.userRole != role { // ✅ 변경 사항이 있을 때만 업데이트
                    self.userRole = role
                }
            }
        }
    }
}
