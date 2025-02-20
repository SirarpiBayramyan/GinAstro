//
//  NumerologyCard.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//

import SwiftUI

// Expandable Numerology Card UI
struct NumerologyCard: View {

    let title: String
    let number: Int?
    let meaning: String
    
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("\(title): \(number ?? 0)")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .foregroundStyle(Color.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                )
            }

            if isExpanded {
                Text(meaning)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.3))
                        .shadow(radius: 2)
                    )
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isExpanded)
    }
}
