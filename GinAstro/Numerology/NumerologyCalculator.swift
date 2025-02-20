//
//  NumerologyCalculator.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//

import Foundation

struct NumerologyCalculator {

    // Calculate Life Path Number (based on Birthdate)
    static func calculateLifePathNumber(day: Int, month: Int, year: Int) -> Int {
        return reduceToSingleDigit(day + month + year)
    }

    // Calculate Destiny Number (based on Full Name)
    static func calculateDestinyNumber(fullName: String) -> Int {
        let letterValues = fullName.uppercased().compactMap { letterToNumber($0) }
        return reduceToSingleDigit(letterValues.reduce(0, +))
    }

    // Calculate Personal Year Number (based on Current Year + Birthdate)
    static func calculatePersonalYearNumber(day: Int, month: Int, currentYear: Int) -> Int {
        return reduceToSingleDigit(day + month + currentYear)
    }

    // Reduce numbers to a single digit (except Master Numbers 11, 22, 33)
    private static func reduceToSingleDigit(_ num: Int) -> Int {
        var number = num
        while number > 9 && number != 11 && number != 22 && number != 33 {
            number = String(number).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return number
    }

    // Convert letters to numerology values
    private static func letterToNumber(_ letter: Character) -> Int? {
        let mapping: [Character: Int] = [
            "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9,
            "J": 1, "K": 2, "L": 3, "M": 4, "N": 5, "O": 6, "P": 7, "Q": 8, "R": 9,
            "S": 1, "T": 2, "U": 3, "V": 4, "W": 5, "X": 6, "Y": 7, "Z": 8
        ]
        return mapping[letter]
    }
}
