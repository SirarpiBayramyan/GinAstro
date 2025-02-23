//
//  HoroscopeView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//
import SwiftUI

struct HoroscopeView: View {
    
    @Namespace var namespace
    @StateObject var viewModel: HoroscopeViewModel
    @State private var selectedSign: ZodiacSign = .aries
    @State private var selectedPeriod: HoroscopePeriod = .daily

    init(viewModel: HoroscopeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Image(selectedSign.bgImageName)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 250)

            VStack(spacing: 12) {
                Image(selectedSign.signImageName)
                    .resizable()
                    .frame(width: 150, height: 150)

                zodiacsContent


                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 2)
                    .opacity(0.3)
                    .padding(.bottom, 24)

                periodContent
                contentView
                Spacer()
            }
        }
        .padding()
        .custombackground
        .customBackButton()
        .toolbarImageTitle(viewModel.category.imageName)
        .onAppear {
            withAnimation {
                viewModel.intentHandler.loadHoroscope(for: selectedSign, period: selectedPeriod, category: viewModel.category)
            }
        }
        .onChange(of: selectedSign) { _ ,newSign in
            withAnimation {
                viewModel.intentHandler.loadHoroscope(for: newSign, period: selectedPeriod, category: viewModel.category)
            }
        }
        .onChange(of: selectedPeriod) { _ ,newPeriod in
            withAnimation {
                viewModel.intentHandler.loadHoroscope(for: selectedSign, period: newPeriod, category: viewModel.category)
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            Text("Select your sign and period to get your horoscope.")
                .foregroundColor(.gray)
        case .loading:
            VStack {
                Spacer()
                ProgressView("Loading your horoscope...")
            }
        case .success(let horoscope):
            ScrollView {
                Text(horoscope)
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .background(Color.gray.opacity(0.3))
            .cornerRadius(12)

        case .failure(let error):
            Text("Failed to load horoscope: \(error.localizedDescription)")
                .foregroundColor(.red)
        }
    }

    private var periodContent: some View {
        HStack {
            ForEach(HoroscopePeriod.allCases, id: \.self) { period in
                VStack(spacing: 8) { // Remove any extra spacing
                    ZStack {
                        Text(period.rawValue)
                            .fontWeight(.light)
                            .font(.callout)
                            .foregroundColor(.white)
                            .background(
                                Capsule() // Use Capsule for better fit
                                    .fill(selectedPeriod == period ? Color.blue : Color.gray)
                                    .opacity(0.5)
                                    .frame(width: 75, height: 30) // Adjusted height
                            )
                    }

                    if selectedPeriod == period {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .matchedGeometryEffect(id: "category_bg", in: namespace)
                            .frame(height: 2)
                            .offset(y: 5) // Reduced offset to remove extra padding
                    }
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedPeriod = period
                    }
                }
            }
        }
        .frame(height: 40) // Set a fixed height to avoid unnecessary padding
    }


    private var zodiacsContent: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ZodiacSign.allCases, id: \.self) { sign in
                        Button(action: {
                            selectedSign = sign
                            withAnimation {
                                scrollProxy.scrollTo(sign, anchor: .center) // Auto-scroll
                            }
                        }) {
                            VStack {
                                Image(sign.signImageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text(sign.rawValue)
                                    .font(.caption)
                            }
                            .padding()
                            .frame(width: 95)
                            .frame(height: 70)
                            .background(selectedSign == sign ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .id(sign) // Assign unique ID for scrolling
                    }
                }
            }
            .onAppear {
                scrollProxy.scrollTo(selectedSign, anchor: .center)
            }
        }
    }
}



#Preview {
    HoroscopeView(viewModel: HoroscopeViewModel(category: .family))
}

import SwiftUI

struct ToolbarImageTitle: ViewModifier {
    var imageName: String
    var size: CGFloat = 40 // Default size

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(systemName: imageName)
                        .resizable()
                        .foregroundStyle(Color.white)
                        .scaledToFit()
                        .frame(width: size, height: size)
                }
            }
    }
}

// Extension for easier usage
extension View {
    func toolbarImageTitle(_ imageName: String, size: CGFloat = 40) -> some View {
        self.modifier(ToolbarImageTitle(imageName: imageName, size: size))
    }
}
