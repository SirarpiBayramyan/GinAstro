//
//  TarotViewModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//

import Combine
import SwiftUI

class TarotViewModel: ObservableObject {

    @Published var drawnCards: [TarotCard] = []
    @Published var aiPredictions: [String: String] = [:]
    @Published var tapCount = 0
    @Published var isLoading = false
    @Published private(set) var predictionsLoaded = false

    private let contentService = ContentGeneratorService()
    private var cancellables = Set<AnyCancellable>()
    var category: ContentCategory

    init(category: ContentCategory) {
        self.category = category
    }

    func drawCard() {
        guard tapCount < 3 else { return }

        let newCard = TarotCard.drawRandomCard()
        withAnimation(.easeInOut(duration: 0.5)) {
            drawnCards.append(newCard)
            tapCount += 1
        }
        fetchTarotPrediction(for: newCard, position: tapCount)

    }

    private func fetchTarotPrediction(for card: TarotCard, position: Int) {
        let positionText = ["Past", "Present", "Future"][position - 1]
        let prompt = "Perform a tarot reading for '\(card.rawValue)' in the \(positionText) position. Explain its meaning."

        isLoading = true
        contentService.generateTarotReading(for: prompt)
            .sink(receiveCompletion: { _ in }, receiveValue: { interpretation in
                DispatchQueue.main.async {
                    self.aiPredictions[card.id] = interpretation

                    if self.aiPredictions.count == 3 { // ✅ NEW: Check if all 3 predictions have loaded
                        self.predictionsLoaded = true
                        self.isLoading = false
                    }
                }
            })
            .store(in: &cancellables)
    }

    func resetReading() {
        withAnimation {
            drawnCards.removeAll()
            aiPredictions.removeAll()
            tapCount = 0
            predictionsLoaded = false
        }
    }

}
