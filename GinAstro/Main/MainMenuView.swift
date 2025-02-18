//
//  MainMenuView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//

import SwiftUI

struct MainMenuView: View {
    let user: User // Authenticated user

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Welcome Message
                Text("Welcome, \(user.name) ✨")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .foregroundStyle(Color.white)

                // Menu Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {

                    // Horoscope View
                    NavigationLink(destination: HoroscopeView()) {
                        MenuItemView(icon: user.zodiacSign()?.signImageName ?? "" , title: "Horoscope")
                    }

                    // Dream Catcher View
                    NavigationLink(destination: DreamView()) {
                        MenuItemView(icon: "dreamcatcher", title: "Dream Catcher")
                    }

                    // Tarot View
                    NavigationLink(destination: TarotView()) {
                        MenuItemView(icon: "book.fill", title: "Tarot Reading")
                    }

                    // Live Chat AI View
                    NavigationLink(destination: LiveChatView()) {
                        MenuItemView(icon: "message.fill", title: "Live Chat AI")
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Logout Button
                Button(action: {
                    logout()
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 36)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
            .custombackground
        }
    }

    // Logout Function
    private func logout() {
        UserDefaults.standard.cachedUser = nil
        AuthModel().state = .unauthenticated // Update Auth State
    }
}

#Preview {
    MainMenuView(
        user: User(
                id: "",
                name: "aa",
                email: "aa@gmail.ccom",
                birthdate: .distantPast,
                gender: .male
        )
    )
}
