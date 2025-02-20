//
//  ChatViewModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 20.02.25.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessageUI] = []

    private let contentService = ContentGeneratorService(model: "gpt-4")
    private var cancellables = Set<AnyCancellable>()
    private var user: User?

    init(user: User?) {
        self.user = user
        addWelcomeMessage()
    }

    func sendMessage(text: String) {
        guard !text.isEmpty else { return }
        guard let user = user else { return }

        let userMessage = ChatMessageUI(id: UUID(), text: text, isUser: true)
        messages.append(userMessage)

        // Show AI typing animation
        let typingIndicator = ChatMessageUI(id: UUID(), text: "typing...", isUser: false, isTyping: true)
        messages.append(typingIndicator)

        // Fetch AI response with user details
        contentService.chatWithAI(userInput: text, user: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.messages.removeAll { $0.isTyping }

                let aiMessage = ChatMessageUI(id: UUID(), text: response, isUser: false)
                self.messages.append(aiMessage)
            })
            .store(in: &cancellables)
    }
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessageUI(id: UUID(), text: "Hello \(user?.name ?? "")! I'm your astrology & psychology assistant. How can I help you today?", isUser: false)
        messages.append(welcomeMessage)
    }
}



// Chat Message Model for UI
struct ChatMessageUI: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
    var isTyping: Bool = false
}
