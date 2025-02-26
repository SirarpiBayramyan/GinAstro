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

                            VStack(alignment: .leading) {
                                Text(viewModel.user?.name ?? "")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.settingsBG)

                                Text(viewModel.user?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.white)


                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .gaSection

                    // About Section
                    Section(header: Text("About")) {
                        NavigationLink(destination: PrivacyPolicyView()) {
                            Text("Privacy Policy")
                        }
                        .gaSection
                    }


                    Section(header: Text("Account")) {
                        Button(action: {
                            showAlert = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Account")
                            }
                            .foregroundStyle(Color.red)
                        }
                        .gaSection
                    }

                    Section {
                        Text("Version: \(viewModel.version)")
                    }
                    .gaSection



                }
                .scrollContentBackground(.hidden)
                .background(Color.settingsBG)


            }
            .navigationTitle("Settings")
            .customBackButton()

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
        .background(Color.settingsBG)
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

#Preview {
    @State var state: AuthState = .authenticated
    return SettingsView(
        viewModel: SettingsViewModel(
            authViewModel: AuthViewModel()),
        authState: $state
    )
}

