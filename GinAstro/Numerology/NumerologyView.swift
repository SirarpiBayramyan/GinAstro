//
//  NumerologyView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//
import SwiftUI

struct NumerologyView: View {

    @StateObject private var viewModel =  NumerologyViewModel()

    var body: some View {
        VStack {
            Text("Numerology for \(viewModel.fullName)")
                .font(.title)
                .bold()
                .padding(.vertical, 20)
                .foregroundColor(.white)

            ExpandableDateCalculator(viewModel: viewModel)
                .padding(.vertical, 36)


            NumerologyResults(viewModel: viewModel)


            Spacer()
        }
        .padding()
        .custombackground
        .customBackButton()
    }

    var dateCalculator: some View {
        VStack {
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
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10) // Rounded corners
                    .foregroundColor(.black)



            }
            .padding(.bottom, 10)

            // Calculate Button
            Button(action: {
                viewModel.calculateNumerology()
            }) {
                Text("Calculate")
                    .font(.title3)
            }
            .gaButton
        }
        .foregroundStyle(Color.white)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.3))
        }
    }
}

// Display User's Numerology Numbers
struct NumerologyResults: View {

    @ObservedObject var viewModel: NumerologyViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                NumerologyCard(title: "Life Path Number", number: viewModel.userLifePathNumber, meaning: viewModel.lifePathPrediction)
                NumerologyCard(title: "Destiny Number", number: viewModel.userDestinyNumber, meaning: viewModel.destinyPrediction)
                NumerologyCard(title: "Personal Year Number", number: viewModel.userPersonalYearNumber, meaning: viewModel.personalYearPrediction)
            }
        }
    }
}

#Preview {
    NumerologyView()
}
