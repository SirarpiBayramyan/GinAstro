//
//  SettingsView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 24.02.25.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var authState: AuthState
    @State private var showAlert = false

    init(viewModel: SettingsViewModel, authState: Binding<AuthState>) {
        self.viewModel = viewModel
        self._authState = authState
    }

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)

                            VStack(alignment: .leading) {
                                Text(viewModel.user?.name ?? "")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Text(viewModel.user?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    // About Section
                    Section(header: Text("About")) {
                        NavigationLink(destination: PrivacyPolicyView()) {
                            Text("Privacy Policy")
                        }
                    }

                    Section(header: Text("Account")) {
                        Button(action: {
                            showAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                Text("Delete Account")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    Section {
                        Text("Version: \(viewModel.version)")
                    }

                }
            }
            .navigationTitle("Settings")


            // Logout Button
            Button(action: {
                viewModel.logout()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .frame(width: 200, height: 36)
            }
            .gaButton
            .padding(.vertical, 30)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteAccount(completion: {
                        presentationMode.wrappedValue.dismiss()
                        authState = .unauthenticated
                    })

                },
                secondaryButton: .cancel()
            )
        }
    }
}

