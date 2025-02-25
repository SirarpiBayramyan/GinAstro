//
//  gaSection.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 25.02.25.
//

import SwiftUI

struct SectionBackground: ViewModifier {
       var color: Color

       func body(content: Content) -> some View  {
           content
               .padding()
               .foregroundStyle(Color.settingsBG)
               .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)) // Standard spacing
               .frame(maxWidth: .infinity, minHeight: 42,  alignment: .leading) // Standard row height
               .background(
                   RoundedRectangle(cornerRadius: 12)
                       .fill(color)
                       .padding(.horizontal, -16) // Expand to cover full width
               )
               .listRowBackground(Color.clear) // Ensure background applies to all rows
    }
}

// Extension for easy reuse
extension View {
    var gaSection: some View {
        self.modifier(SectionBackground(color: .white.opacity(0.6)))
    }
}


struct SectionHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
            .foregroundColor(.white) // Ensure good contrast
    }
}

// Extension for easy reuse
extension View {
    var gaSectionHeaderStyle: some View {
        self.modifier(SectionHeaderModifier())
    }
}
