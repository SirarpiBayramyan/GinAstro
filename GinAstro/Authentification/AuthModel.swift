//
//  AuthModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import Foundation

class AuthModel: ObservableObject {

    @Published var state: AuthState = .unauthenticated
    var intent: AuthIntent? // No strong reference inside AuthIntent

    init(authService: FirebaseAuthService = FirebaseAuthService()) {
        self.intent = AuthIntent(model: self, authService: authService)
    }
}

