//
//  PrivacyPolicyView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 24.02.25.
//

import SwiftUI

struct PrivacyPolicyView: View {

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Text("Last Updated: February 2025")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Divider()

                    // Section 1: Introduction
                    Text("1. Introduction")
                        .font(.headline)
                    Text("Welcome to ginAstro! Your privacy is important to us. This policy explains how we collect, use, and protect your personal information when using our app.")

                    // Section 2: Data Collection
                    Text("2. Information We Collect")
                        .font(.headline)
                    Text("We collect the following types of information to provide and improve our services:")
                    VStack(alignment: .leading) {
                        Text("• Personal Information: Name, email address, and profile details if provided.")
                        Text("• Usage Data: App interactions, preferences, and analytics data.")
                        Text("• Location Data: If enabled, for personalized astrology readings.")
                    }

                    // Section 3: How We Use Your Data
                    Text("3. How We Use Your Information")
                        .font(.headline)
                    Text("We use your data to:")
                    VStack(alignment: .leading) {
                        Text("• Personalize astrology readings and insights.")
                        Text("• Improve app performance and features.")
                        Text("• Send notifications and updates (if enabled).")
                    }

                    // Section 4: Data Security
                    Text("4. Data Security")
                        .font(.headline)
                    Text("We prioritize your data security and use industry-standard measures to protect your information. However, no digital platform is 100% secure.")

                    // Section 5: Third-Party Services
                    Text("5. Third-Party Services")
                        .font(.headline)
                    Text("We may use third-party services (such as analytics or ads) that have their own privacy policies. We recommend reviewing their policies.")

                    // Section 6: Your Rights
                    Text("6. Your Rights & Choices")
                        .font(.headline)
                    Text("You have the right to access, update, or delete your data. You can also disable certain features like location tracking in the app settings.")

                    // Section 7: Contact Us
//                    Text("7. Contact Us") // TODO: ContactUS
//                        .font(.headline)
//                    Text("If you have any questions about this Privacy Policy, please contact us at support@ginastro.com.")

                    Divider()

                    // Dismiss Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                            .font(.headline)
                    }
                    .gaButton
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationBarTitle("Privacy Policy", displayMode: .inline)
        }
    }
}


#Preview {
    PrivacyPolicyView()
}
