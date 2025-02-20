//
//  GAButtonStyle.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import SwiftUI

struct GAButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 200, height: 36)
            .background(Color.gray.opacity(0.6))
            .foregroundStyle(Color.white)
            .cornerRadius(10)
    }

}

extension View {

    var gaButton: some View {
        self.buttonStyle(GAButtonStyle())
    }
}

