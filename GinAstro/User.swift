//
//  User.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//
import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let birthdate: Date
    let gender: Gender

    func zodiacSign() -> ZodiacSign? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: birthdate)

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

}


enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"

    var id: String { self.rawValue }
}
