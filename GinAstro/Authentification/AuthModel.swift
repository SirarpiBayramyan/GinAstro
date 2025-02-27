//
//  AuthModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import Foundation
import Combine
import FirebaseAuth
import SwiftUI

enum AuthState: Equatable {
    case idle
    case loading
    case error(String)
    case authenticated
    case unauthenticated // Explicitly state when the user is logged out
}


class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .idle
    @Published var currentUser: User?
    @Published var isRegistering = false
    init() {
        checkAuthentication()
    }

    private let authService = FirebaseAuthService()
    private var cancellables = Set<AnyCancellable>()

    // Check if user is logged in
    func checkAuthentication() {
        self.authState = .loading
        authService.fetchCurrentUser()
            .sink(receiveCompletion: { _ in }, receiveValue: { user in
                DispatchQueue.main.async {
                    if let user = user {
                        self.currentUser = user
                        self.authState = .authenticated
                    } else {
                        self.authState = .unauthenticated // Explicitly set when no user is found
                    }
                }
            })
            .store(in: &cancellables)
    }

    // Login User
    func login(email: String, password: String) {
        authState = .loading
        authService.loginUser(email: email, password: password)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        self.authState = .error(error.localizedDescription)
                    }
                }
            }, receiveValue: {
                self.checkAuthentication()
            })
            .store(in: &cancellables)
    }

    // Register User
    func register(name: String, email: String, password: String, birthdate: Date, gender: Gender) {
        authState = .loading
        authService.registerUser(name: name, email: email, password: password, birthdate: birthdate, gender: gender)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        self.authState = .error(error.localizedDescription)
                    }
                }
            }, receiveValue: { user in
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.authState = .authenticated
                }
            })
            .store(in: &cancellables)
    }

    // Logout
    func logout(completion: @escaping () -> Void) {
        authService.logout()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                withAnimation {
                    self?.unauthenticate(completion)
                }
            })
 .store(in: &cancellables)
    }

    func deleteAccount(completion: @escaping () -> Void) {
        authService.deleteAccount()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.authState = .error("can't be deleted") // not correct not authentication error
                }
            }, receiveValue: { [weak self] _ in
                print("Account deleted successfully")
                withAnimation {
                    self?.unauthenticate(completion)
                }

            })
            .store(in: &cancellables)

    }


    private func unauthenticate(_ completion: @escaping () -> Void) {
        completion()
        authState = .unauthenticated
        isRegistering = false
    }

}
