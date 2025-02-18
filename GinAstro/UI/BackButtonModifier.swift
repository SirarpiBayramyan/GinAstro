//
//  BackButtonModifier.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 17.02.25.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {

    @Environment(\.presentationMode) var presentationMode

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")

                }
            })
            .foregroundColor(.white)
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButtonModifier())
    }
}


