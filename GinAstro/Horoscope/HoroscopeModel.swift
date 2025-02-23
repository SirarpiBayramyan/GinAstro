//
//  HoroscopeModel.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 18.02.25.
//

import Foundation

enum HoroscopePeriod: String, CaseIterable {

    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"


    func periodPrompt(for sign: String) -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
          let currentMonth = Calendar.current.component(.month, from: Date())
          let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
          let currentDay = Calendar.current.component(.day, from: Date())

          var prompt = ""
          switch self {
          case .daily:
              prompt = "Provide a horoscope for the \(sign) zodiac sign for today."
          case .weekly:
              prompt = "Provide a weekly horoscope for the \(sign) zodiac sign this week \(currentWeek) of \(currentYear)."
          case .monthly:
              prompt = "Provide a monthly horoscope for the \(sign) zodiac sign for this month \(currentMonth) of \(currentYear)."
          case .yearly:
              prompt = "Provide a yearly horoscope for the \(sign) zodiac sign for this year \(currentYear)."
          }

          return prompt
    }


}

struct Horoscope: Identifiable {
    let id = UUID()
    let period: HoroscopePeriod
    let sign: String
    let content: String
}

