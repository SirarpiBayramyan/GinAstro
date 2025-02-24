//
//  AuthView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import SwiftUI

struct AuthView: View {

    @ObservedObject var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var birthdate = Date()
    @State private var gender: Gender = .female

    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            if viewModel.authState == .loading {
                FullScreenGifView()
            } else {
                if viewModel.currentUser != nil && viewModel.authState != .unauthenticated {
                    MainMenuView(authViewModel: viewModel)
                } else {
                    authContent
                }
            }
        }
        .onChange(of: viewModel.authState) { _, newValue in
            if case .error(let message) = newValue {
                errorMessage = "Error: \(message)"
            } else {
                errorMessage = nil
            }
        }
        .onChange(of: viewModel.isRegistering) { oldValue, newValue in
            errorMessage = nil
        }
    }
    
    @ViewBuilder
    private var authContent: some View {
        VStack {
            Spacer()
            
            Text(viewModel.isRegistering ? "Create Account" : "Login")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            if viewModel.isRegistering {
                CustomTextField(text: $name, placeholder: "Name")
            }
            
            CustomTextField(text: $email, placeholder: "Email")
            
            CustomTextField(text: $password, placeholder: "Password", isSecure: true)
            
            Group {
                if viewModel.isRegistering {
                    VStack(spacing: 10) {
                        DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                        
                        RoundedRectangle(cornerRadius: 1).fill(Color.white)
                            .frame(height: 1)
                        // Gender Picker
                        Picker("Gender", selection: $gender) {
                            Text("Female").tag(Gender.female)
                            Text("Male").tag(Gender.male)
                            Text("Other").tag(Gender.other)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.3)))
            
            
            Button(action: {
                withAnimation {
                    if viewModel.isRegistering {
                        viewModel.register(name: name, email: email, password: password, birthdate: birthdate, gender: gender)
                    } else {
                        viewModel.login(email: email, password: password)
                    }
                }
            }) {
                Text(viewModel.isRegistering ? "Sign Up" : "Login")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .gaButton
            .padding(.top)
            
            // Error & Loading State
            switch viewModel.authState {
            case .loading:
                ProgressView().padding()
            case .error(let message):
                Group {
                    if let message = errorMessage {
                        Text(message)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        EmptyView()
                    }

                }

            default:
                EmptyView()
            }
            
            // Toggle between login & registration
            Button(action: {
                viewModel.isRegistering.toggle()
            }) {
                Text(viewModel.isRegistering ? "Already have an account? Login" : "Don't have an account? Sign up")
            }
            .padding()
            Spacer()
        }
        .foregroundStyle(Color.white)
        .padding()
        .custombackground
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}
