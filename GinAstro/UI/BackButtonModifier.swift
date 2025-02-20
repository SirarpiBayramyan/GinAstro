//
//  BackButtonModifier.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 17.02.25.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {

    @Environment(\.presentationMode) var presentationMode
    private var isWithText: Bool
    init(isWithText: Bool) {
        self.isWithText = isWithText
    }

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    if isWithText {
                        Text("Back")
                    }
                }
            })
            .foregroundColor(.white)
    }
}

extension View {
    func customBackButton(isWithText: Bool = true) -> some View {
        self.modifier(CustomBackButtonModifier(isWithText: isWithText))
    }
}


