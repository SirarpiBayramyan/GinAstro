//
//  LiveChatView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//
import SwiftUI

struct ChatView: View {

    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isTextFieldFocused: Bool

    init(viewModel: ChatViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(
                                message: message,
                                messages: viewModel.messages,
                                onReply: { repliedMessage in
                                    viewModel.replyToMessageID = repliedMessage.id //
                                }
                            )
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

            // 🔹 Show reply preview above the input field before sending
            if let replyToMessageID = viewModel.replyToMessageID,
               let repliedMessage = viewModel.messages.first(where: { $0.id == replyToMessageID }) {

                HStack {
                    VStack(alignment: .leading) {
                        Text("Replying to:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(repliedMessage.text)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button(action: { viewModel.replyToMessageID = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            }

            // 🔹 Message Input Field
            HStack {
                CustomTextField(text: $viewModel.userInput, placeholder: "Type your message...")
                    .focused($isTextFieldFocused)
                Button(action: {

                    viewModel.replyMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                }
            }
            .padding()
        }
        .onAppear {
            isTextFieldFocused = true  // 🆕 Ensure keyboard appears when the view loads
        }
        .custombackground
        .customBackButton(isWithText: false)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Psycho Astro Chat")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.white)
            }
        }
    }
}


struct ChatBubble: View {
    let message: ChatMessageUI
    let messages: [ChatMessageUI]  // Pass all messages for lookup
    var onReply: (ChatMessageUI) -> Void  // Reply action handler

    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {

            if message.isUser, let replyMessage = messages.first(where: { $0.id == message.repliedToMessageID }) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(replyMessage.text)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(6)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: 200, alignment: message.isUser ? .trailing : .leading)
                }
            }

            Text(message.text)
                .padding()
                .background(message.isUser ? Color.blue.opacity(0.7) : Color.gray.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(12)
                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = message.text
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }

                    Button(action: {
                        onReply(message)  // Reply action
                    }) {
                        Label("Reply", systemImage: "arrowshape.turn.up.left")
                    }
                }

            Text(formatDate(message.timestamp))
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
        }
        .padding(.horizontal)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Example: "3:45 PM"
        return formatter.string(from: date)
    }
}

#Preview {
    ChatView(
        viewModel: ChatViewModel(
            user: User(
                id: "",
                name: "jj",
                email: "mkn@gmail.com",
                birthdate: .now,
                gender: .male
            )
        )
    )
}
