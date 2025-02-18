//
//  MenuItemView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import SwiftUI

struct MenuItemView: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .padding()
                .clipShape(Circle())

            Text(title)
                .font(.system(size: 16))
                .fontWeight(.semibold)
        }
        .tint(.white)
        .padding()
        .frame(width: 150, height: 150)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


#Preview {
    MenuItemView(
        icon: "star.circle.fill",
        title: "Dream Catcher"
    )
}
