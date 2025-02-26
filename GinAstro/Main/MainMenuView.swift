//
//  MainMenuView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//

import SwiftUI

struct MainMenuView: View {

    @ObservedObject var authViewModel: AuthViewModel
    @State var state: AuthState
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        state = authViewModel.authState
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
                ScrollView {
                    // Menu Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        // Horoscope View
                        NavigationLink(destination: CategorySelectionView(destinationView: { selectedCategory in
                            HoroscopeView(
                                viewModel: HoroscopeViewModel(
                                    category: selectedCategory,
                                    user: authViewModel.currentUser
                                )
                            )
                        }, title: "Horoscope")) {
                            MenuItemView(icon: authViewModel.currentUser?.zodiacSign()?.signImageName ?? "", title: "Horoscope")
                        }
                        // Dream Catcher View
                        NavigationLink(destination: DreamView()) {
                            MenuItemView(icon: "dreamcatcher", title: "Dream Catcher")
                        }

                        // Tarot View
                        NavigationLink(destination: CategorySelectionView(destinationView: { selectedCategory in
                            TarotView(viewModel: TarotViewModel(category: selectedCategory))
                        }, title: "Tarot Reading")) {
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
                            MenuItemView(icon: "live-chat", title: "Live Chat")
                        }

                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .custombackground
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(
                        destination: SettingsView(
                            viewModel:
                                SettingsViewModel(
                                    authViewModel: authViewModel
                                ), authState: $state
                        )
                    ) {  // Change `SettingsView()` to your desired destination
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear{
            GaAnalytics.logScreen(name: "main_screen")
        }
    }

}

#Preview {
    MainMenuView(
        authViewModel: AuthViewModel()
    )
}

