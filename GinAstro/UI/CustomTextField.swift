//
//  CustomTextField.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 20.02.25.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @State private var isSecureField: Bool = true
    @FocusState private var isFocused: Bool
    
    var placeholder: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            
            
            if isSecure {
                if isSecureField {
                    SecureField("", text: $text)
                        .focused($isFocused)
                        .foregroundColor(.white)
                        .overlay(placeholderView, alignment: .leading)
                } else {
                    TextField("", text: $text)
                        .focused($isFocused)
                        .foregroundColor(.white)
                        .overlay(placeholderView, alignment: .leading)
                }
            } else {
                TextField("", text: $text)
                    .focused($isFocused)
                    .foregroundColor(.white)
                    .overlay(placeholderView, alignment: .leading)
            }
            
            // Show Eye Button Only for Secure Fields
            if isSecure {
                Button(action: {
                    isSecureField.toggle()
                }) {
                    Image(systemName: isSecureField ? "eye.slash" : "eye")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.4))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.gray : .clear, lineWidth: 1)
        )
    }
    
    // Custom Placeholder Text Overlay
    private var placeholderView: some View {
        Text(placeholder)
            .foregroundColor(.white.opacity(0.6))
            .opacity(text.isEmpty ? 1 : 0)
    }
    
}
