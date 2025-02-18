//
//  AuthView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var model = AuthModel()

    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var birthdate = Date()
    @State private var gender: Gender = .female
    @State private var isRegistering = false

    var body: some View {
        NavigationStack {
            if let cachedUser = UserDefaults.standard.cachedUser {
                // If user is already authenticated, show MainView
                MainMenuView(user: cachedUser)
            } else {
                // Otherwise, show Auth UI
                authContent
            }
        }
        .onAppear {
            // Check if a user is stored in UserDefaults on app launch
            model.intent?.checkAuthentication()
        }
    }

    @ViewBuilder
    private var authContent: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))

            Button(action: {
                model.intent?.login(email: email, password: password)
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top)

            switch model.state {
            case .loading:
                ProgressView()
                    .padding()
            case .error(let message):
                Text("Error: \(message)")
                    .foregroundColor(.red)
                    .padding()
            default:
                EmptyView()
            }

        }
        .padding()
    }
}

#Preview {
    AuthView()
}

