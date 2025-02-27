//
//  SettingsViewModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 24.02.25.
//

import Foundation

class SettingsViewModel: ObservableObject {

    private var authViewModel: AuthViewModel

    var user: User? {
        authViewModel.currentUser
    }

    var version: String {
        "1.0.0"
    }

    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }

    func logout(completion: @escaping () -> Void) {
        authViewModel.logout(completion: completion)
    }

    func deleteAccount(completion: @escaping () -> Void) {
        authViewModel.deleteAccount(completion: completion)
    }
}
