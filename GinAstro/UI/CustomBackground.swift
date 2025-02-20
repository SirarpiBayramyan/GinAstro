//
//  CustomBackground.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//


import SwiftUI

struct CustomBackground: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                Image("launching")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
    }
}

// Extension to make it easy to apply the modifier
extension View {
    var custombackground: some View {
        self.modifier(CustomBackground())
    }
}
