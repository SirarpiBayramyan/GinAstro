//
//  ZodiacSign.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 17.02.25.
//

import Foundation

enum ZodiacSign: String, CaseIterable, Identifiable {

    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"

    var bgImageName: String {
        self.rawValue.lowercased()
    }

    var signImageName: String {
        "ga-\(self.rawValue.lowercased())"
    }

    var id: String { rawValue }

}

extension ZodiacSign {

    func zodiacSign(for date: Date) -> ZodiacSign? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)

        guard let month = components.month, let day = components.day else {
            return nil
        }

        for sign in ZodiacSign.allCases {
            let range = sign.dateRange
            if (month == range.start.month && day >= range.start.day) ||
                (month == range.end.month && day <= range.end.day) {
                return sign
            }
            // Handle Capricorn wrapping around the year-end
            if sign == .capricorn && (month == 12 && day >= 22 || month == 1 && day <= 19) {
                return sign
            }
        }
        return nil
    }


    var dateRange: (start: (month: Int, day: Int), end: (month: Int, day: Int)) {
        switch self {
        case .aries:
            return ((3, 21), (4, 19))
        case .taurus:
            return ((4, 20), (5, 20))
        case .gemini:
            return ((5, 21), (6, 20))
        case .cancer:
            return ((6, 21), (7, 22))
        case .leo:
            return ((7, 23), (8, 22))
        case .virgo:
            return ((8, 23), (9, 22))
        case .libra:
            return ((9, 23), (10, 22))
        case .scorpio:
            return ((10, 23), (11, 21))
        case .sagittarius:
            return ((11, 22), (12, 21))
        case .capricorn:
            return ((12, 22), (1, 19))
        case .aquarius:
            return ((1, 20), (2, 18))
        case .pisces:
            return ((2, 19), (3, 20))
        }
    }
}

