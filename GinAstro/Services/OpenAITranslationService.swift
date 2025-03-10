//
//  OpenAITranslationService.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 17.02.25.
//

import Foundation
import OpenAIKit
import Combine

class ContentGeneratorService {

    private let apiKey: String
    private let model: String
    private var cancellables = Set<AnyCancellable>()
    private var conversationHistory: [ChatMessage] = []

    init(model: String = "gpt-3.5-turbo-instruct") {
        self.apiKey = "you api key"
        self.model = model
    }

    // Generate horoscope
    func generateHoroscope(for sign: String, period: HoroscopePeriod, category: ContentCategory) -> AnyPublisher<String, Error> {
        let prompt = "\(category.categoryPrompt()) for \(sign) for the \(period.rawValue)."
        return generateContent(with: prompt.lowercased())

    }

    // Generate Dream Interpretation
    func generateDreamInterpretation(for dream: String) -> AnyPublisher<String, Error> {
        let prompt = "Interpret the following dream: '\(dream)'. Provide a detailed and insightful analysis, including any symbolic meanings."

        return generateContent(with: prompt)
    }

    // Generate tarot reading
    func generateTarotReading(for question: String) -> AnyPublisher<String, Error> {
        let prompt = "Perform a tarot reading for the following question: \(question)"
        return generateContent(with: prompt)
    }

    // Generate Numerology Meaning
    func generateNumerologyMeaning(for number: Int, type: String) -> AnyPublisher<String, Error> {
        let prompt = """
            Provide a detailed meaning of Numerology Number \(number) as a \(type).
            Explain personality traits, strengths, weaknesses, and life guidance.
            Format it in a structured and insightful way.
            """

        return generateContent(with: prompt)
    }

    func chatWithAI(userInput: String, user: User) -> AnyPublisher<String, Error> {
        let userMessage = ChatMessage(role: "user", content: userInput)
        conversationHistory.append(userMessage)


        // ✅ Ensure AI's first message is included only once
        if conversationHistory.count == 1 {
            conversationHistory.insert(ChatMessage(role: "assistant", content: "🔮 Hello! I'm your astrology and psychology assistant. Ask me anything!"), at: 0)
        }

        let messages: [ChatMessage] = [
            ChatMessage(role: "system", content: """
               You are an expert astrologer, psychologist, and numerologist.
               Provide deep insights based on astrology, psychology, and numerology.

               User Profile:
               - Name: \(user.name)
               - Birthdate: \(user.birthdate)
               - Zodiac Sign: \(user.zodiacSign()?.rawValue ?? "")
               - Gender: \(user.gender.rawValue)

               Use this information in responses to make them more personal.
               """)
        ] + conversationHistory

        let chatRequest = ChatRequest(model: model, messages: messages)

        return sendRequest(endpoint: "chat/completions", requestBody: chatRequest) // ✅ FIXED ENDPOINT
            .tryMap { (response: ChatResponse) in
                guard let reply = response.choices.first?.message.content else {
                    throw ServiceError.invalidResponse
                }
                let aiMessage = ChatMessage(role: "assistant", content: reply)
                self.conversationHistory.append(aiMessage) // Save AI response
                return reply
            }
            .eraseToAnyPublisher()
    }


    // Generate content based on prompt
    private func generateContent(with prompt: String) -> AnyPublisher<String, Error> {
        let completionRequest = CompletionRequest(
            model: model,
            prompt: prompt,
            max_tokens: 200,
            temperature: 0.7
        )
        return sendRequest(endpoint: "completions", requestBody: completionRequest)
            .tryMap { (response: CompletionResponse) in
                guard let text = response.choices.first?.text else {
                    throw ServiceError.invalidResponse
                }
                return text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .eraseToAnyPublisher()
    }

    // Generic function to send requests
    private func sendRequest<T: Codable, U: Codable>(endpoint: String, requestBody: T) -> AnyPublisher<U, Error> {
        guard let url = URL(string: "https://api.openai.com/v1/\(endpoint)") else {
            return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(2) // Retries the request twice upon failure
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ServiceError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    let errorDetail = String(data: data, encoding: .utf8) ?? "No error details"
                    throw ServiceError.serverError(statusCode: httpResponse.statusCode, detail: errorDetail)
                }
                return data
            }
            .decode(type: U.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
// Service error definitions
enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, detail: String)

}

// Request model for text completions
struct CompletionRequest: Codable {
    let model: String
    let prompt: String
    let max_tokens: Int
    let temperature: Double
}

// Response model for text completions
struct CompletionResponse: Codable {
    struct Choice: Codable {
        let text: String
    }
    let choices: [Choice]
}

// Request model for chat completions
struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}

// Response model for chat completions
struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}

