//
//  LiveChatView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import SwiftUI

struct ChatView: View {

    @StateObject private var viewModel: ChatViewModel
    @State private var userInput = ""

    init(viewModel: ChatViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _, _ in
                    withAnimation {
                        scrollView.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }

            HStack {
                CustomTextField(text: $userInput, placeholder: "Type your message...")

                Button(action: {
                    guard !userInput.isEmpty else { return }
                    viewModel.sendMessage(text: userInput)
                    userInput = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .opacity(0.5)
                }
            }
            .padding()
        }
        .custombackground
        .customBackButton(isWithText: false)
        .navigationTitle("Psycho Astro Chat")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Psycho Astro Chat")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }

        }
    }
}
    struct ChatBubble: View {
        let message: ChatMessageUI

        @State private var dots = "." // Start with one dot
        private let animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

        var body: some View {
            HStack {
                if message.isUser { Spacer() }

                if message.isTyping {
                    Text("Typing\(dots)")
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .foregroundStyle(Color.white)
                        .cornerRadius(12)
                        .frame(maxWidth: 100)
                        .onReceive(animationTimer) { _ in
                            if dots.count >= 3 {
                                dots = "." // Reset after 3 dots
                            } else {
                                dots.append(".") // Add another dot
                            }
                        }
                } else {
                    // ✅ Regular Message
                    Text(message.text)
                        .padding()
                        .background(message.isUser ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                        .foregroundStyle(Color.white)
                        .cornerRadius(12)
                        .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
                }

                if !message.isUser { Spacer() }
            }
        }
    }
