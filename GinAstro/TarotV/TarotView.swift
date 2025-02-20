//
//  TarotView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import SwiftUI

struct TarotDeckView: View {

    @StateObject private var viewModel = TarotViewModel()
    @State private var poppedCards: [String: Bool] = [:] // Track popped state for each card
    @State private var currentCard: TarotCard? = nil // Floating card when drawn

    var body: some View {
        VStack {
            Text("Tarot Reading")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            tenseCardsContent

            deckContent

            if viewModel.tapCount == 3 {
                if viewModel.predictionsLoaded {
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 2)
                        .opacity(0.3)
                        .padding()
                    predictionResults
                } else {
                    Text("Loading Predictions...")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            // Floating pop effect when drawing a card
            if let card = currentCard {
                TarotCardView(card: card, isFlipped: true, isPopped: true)
                    .transition(.scale.combined(with: .opacity))
                    .offset(y: -100)  // Floating effect when drawn
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: currentCard)
            }
            Spacer()
        }
        .custombackground.opacity(0.9)
        .customBackButton()
    }


    private var deckContent: some View {
        ZStack {
            if viewModel.tapCount < 3 {  // Show deck only if not all cards are drawn
                ForEach(0..<22, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: [Color.blue.opacity(0.8), Color.black], startPoint: .top, endPoint: .bottom))
                        .frame(width: 100, height: 160) // Slightly larger cards
                        .overlay(
                            Image("taro-closed")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                        )
                        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 2, y: 4) // Adds subtle depth
                        .rotationEffect(.degrees(Double(index - 11) * 3)) // More natural fan spread
                        .offset(x: CGFloat(index - 11) * 3, y: CGFloat(abs(index - 11)) * -1.5)
                        .zIndex(Double(22 - index)) // Maintains correct stacking order
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.tapCount) // Smooth animation
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                viewModel.drawCard()
                            }
                        }
                }
            }
        }
        .padding()

    }

    // Display Past, Present, and Future Cards
    private var tenseCardsContent: some View {
        HStack(spacing: 30) {
            CardSlot(
                title: "Past",
                card: viewModel.drawnCards.indices.contains(0) ? viewModel.drawnCards[0] : nil,
                isPopped: ((viewModel.drawnCards.indices.contains(0) ? viewModel.aiPredictions[viewModel.drawnCards[0].id] : nil) != nil),
                onTap: {}
            )

            CardSlot(
                title: "Present",
                card: viewModel.drawnCards.indices.contains(1) ? viewModel.drawnCards[1] : nil,
                isPopped: ((viewModel.drawnCards.indices.contains(1) ? viewModel.aiPredictions[viewModel.drawnCards[1].id] : nil) != nil),
                onTap: {}
            )

            CardSlot(
                title: "Future",
                card: viewModel.drawnCards.indices.contains(2) ? viewModel.drawnCards[2] : nil,
                isPopped: ((viewModel.drawnCards.indices.contains(2) ? viewModel.aiPredictions[viewModel.drawnCards[2].id] : nil) != nil),
                onTap: {}
            )
        }
        .padding(.bottom, 50)

    }

    // Scrollable AI Tarot Predictions
    private var predictionResults: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach($viewModel.drawnCards, id: \.id) { card in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(card.id)
                            .font(.callout)
                            .bold()

                        Text(viewModel.aiPredictions[card.id] ?? "Loading...")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            //.padding()
        }
        .frame(maxHeight: 300)
    }
    // Draw a card one by one for Past, Present, and Future
    private func drawNextCard() {
        guard viewModel.tapCount < 3 else { return }  // Stop after 3 taps

        if let newCard = TarotCard.allCases.shuffled().first(where: { card in
            !viewModel.drawnCards.contains { $0.id == card.id }
        }) {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentCard = newCard  // Show card floating up from deck
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {  // Delay placing into slot
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    viewModel.drawnCards.append(newCard)
                    viewModel.tapCount += 1
                    currentCard = nil  // Remove floating effect
                }
            }
        }
    }

    // Toggle pop effect on a specific card
    private func popCard(_ id: String) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
            poppedCards[id] = !(poppedCards[id] ?? false)
        }
    }
}

struct TarotView: View {

    @StateObject private var viewModel = TarotViewModel()

    var body: some View {
        TarotDeckView()
    }
}

#Preview {
    TarotView()
}
