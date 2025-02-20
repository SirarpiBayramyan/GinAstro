//
//  ExpandableDateCalculator.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//

import SwiftUI

struct ExpandableDateCalculator: View {

    @ObservedObject var viewModel: NumerologyViewModel
    @State private var isExpanded: Bool = false // Track expansion state

    var body: some View {
        VStack {
            // Header Button for Expanding/Collapsing
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Date Calculator")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.title2)
                }
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.3)))
            }

            // Expandable Content
            if isExpanded {
                VStack {
                    // Date Picker
                    HStack {
                        Text("Pick a Date to Calculate:")
                            .font(.headline)
                        Spacer()
                        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.date])
                            .datePickerStyle(DefaultDatePickerStyle())
                            .labelsHidden()
                    }
                    .padding(.bottom, 10)

                    // Name Input for Destiny Number
                    VStack(alignment: .leading) {
                        Text("Enter Full Name:")
                            .font(.headline)
                        TextField("John Doe", text: $viewModel.fullName)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 10)

                    // Calculate Button
                    Button(action: {
                        viewModel.calculateNumerology()
                    }) {
                        Text("Calculate")
                    }
                    .padding(.horizontal)
                    .gaButton
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.3)))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    ExpandableDateCalculator(viewModel: NumerologyViewModel())
}
