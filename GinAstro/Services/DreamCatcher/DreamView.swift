//
//  DreamView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//


import SwiftUI

struct DreamView: View {
    @StateObject private var viewModel = DreamViewModel()

    @State private var dreamInput: String = ""


    var body: some View {
        VStack {
            TextField("Describe your dream...", text: $dreamInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.gray)
                .padding()

            Button("Interpret Dream") {
                viewModel.fetchDreamInterpretation(dream: dreamInput)
            }
            .gaButton

            contentView

            Spacer()
        }
        .custombackground
        .customBackButton()
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            Text("Enter a dream to get an interpretation.")
                .foregroundColor(.gray)
        case .loading:
            ProgressView("Interpreting your dream...")
        case .success(let interpretation):
            ScrollView {
                Text(interpretation)
                    .font(.body)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        case .failure(let error):
            Text("Error: \(error.localizedDescription)")
                .foregroundColor(.red)
        }
    }
}


#Preview {
    DreamView()
}
