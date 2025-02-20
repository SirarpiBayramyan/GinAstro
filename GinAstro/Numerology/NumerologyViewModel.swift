//
//  NumerologyViewModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//
private var user: User? {
    UserDefaults.standard.cachedUser ?? nil
}

import Foundation
import Combine

class NumerologyViewModel: ObservableObject {

    @Published var selectedDate: Date
    @Published var fullName: String

    @Published var userLifePathNumber: Int?
    @Published var userDestinyNumber: Int?
    @Published var userPersonalYearNumber: Int?

    @Published var lifePathPrediction: String = "Select a date and name to generate."
    @Published var destinyPrediction: String = "Enter your full name to generate."
    @Published var personalYearPrediction: String = "Select a date to generate."

    private let contentService =  ContentGeneratorService()
    private var cancellables = Set<AnyCancellable>()
    private var user: User?

    init() {
        self.user = UserDefaults.standard.cachedUser
        self.fullName = user?.name ?? ""
        self.selectedDate = Date() // fix self used before init
        self.selectedDate = getUserStoredBirthdate(user)
        calculateNumerology()
    }

    // Use stored birthdate if available, otherwise use current date
    private func getUserStoredBirthdate(_ user: User?) -> Date {
        guard let user = user else  { return .now }
        let calendar = Calendar.current
        var components = DateComponents()
        let date = user.birthdate
        components.year = date.year
        components.month = date.month
        components.day = date.day
        return calendar.date(from: components) ?? Date()
    }

    // Extract year, month, day from selected date
    private func extractDateComponents(from date: Date) -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return (year: components.year ?? 0, month: components.month ?? 0, day: components.day ?? 0)
    }

    // Calculate Numerology numbers based on user input
    func calculateNumerology() {
        let (year, month, day) = extractDateComponents(from: selectedDate)
        let currentYear = Calendar.current.component(.year, from: Date())

        userLifePathNumber = NumerologyCalculator.calculateLifePathNumber(day: day, month: month, year: year)
        userPersonalYearNumber = NumerologyCalculator.calculatePersonalYearNumber(day: day, month: month, currentYear: currentYear)
        userDestinyNumber = fullName.isEmpty ? nil : NumerologyCalculator.calculateDestinyNumber(fullName: fullName)

        fetchNumerologyMeaning(for: userLifePathNumber, type: "Life Path") { result in
            self.lifePathPrediction = result
        }

        fetchNumerologyMeaning(for: userDestinyNumber, type: "Destiny") { result in
            self.destinyPrediction = result
        }

        fetchNumerologyMeaning(for: userPersonalYearNumber, type: "Personal Year") { result in
            self.personalYearPrediction = result
        }
    }

    // Fetch AI-generated Numerology Meanings
    private func fetchNumerologyMeaning(for number: Int?, type: String, completion: @escaping (String) -> Void) {
        guard let number = number else {
            completion("Invalid \(type) Number.")
            return
        }

        contentService.generateNumerologyMeaning(for: number, type: type)
            .sink(receiveCompletion: { _ in }, receiveValue: { meaning in
                DispatchQueue.main.async {
                    completion(meaning)
                }
            })
            .store(in: &cancellables)
    }
}
