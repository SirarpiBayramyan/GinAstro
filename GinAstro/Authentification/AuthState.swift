//
//  AuthState.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import Foundation

// Authentication states
enum AuthState {

    case unauthenticated
    case loading
    case authenticated(User)
    case error(String)
}

