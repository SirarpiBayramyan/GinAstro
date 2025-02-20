//
//  MainMenuView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//

import SwiftUI

struct MainMenuView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Welcome Message
                Text("Welcome, \(authViewModel.currentUser?.name ?? "") ✨")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .foregroundStyle(Color.white)
                
                // Menu Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    
                    // Horoscope View
                    NavigationLink(destination: HoroscopeView()) {
                        MenuItemView(icon: authViewModel.currentUser?.zodiacSign()?.signImageName ?? "" , title: "Horoscope")
                    }
                    
                    // Dream Catcher View
                    NavigationLink(destination: DreamView()) {
                        MenuItemView(icon: "dreamcatcher", title: "Dream Catcher")
                    }
                    
                    // Tarot View
                    NavigationLink(destination: TarotView()) {
                        MenuItemView(icon: "tarot-reading", title: "Tarot Reading")
                    }
                    //Numerology view
                    NavigationLink(destination: NumerologyView()) {
                        MenuItemView(icon: "numerology", title: "Numerology")
                    }
                    // Live Chat AI View
                    NavigationLink(destination: ChatView(
                        viewModel: ChatViewModel(
                            user: authViewModel.currentUser
                        )
                    )) {
                        MenuItemView(icon: "live-chat", title: "Live Chat AI")
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
        //        UserDefaults.standard.cachedUser = nil
        //        UserDefaults.standard.removeObject(forKey: "cachedUser")
        authViewModel.logout()
    }
}

#Preview {
    MainMenuView(
        authViewModel: AuthViewModel()
    )
}
