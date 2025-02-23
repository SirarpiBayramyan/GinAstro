//
//  ContentCategory.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 23.02.25.
//

import Foundation

enum ContentCategory: String, CaseIterable {
    case general = "General"
    case love = "Love"
    case family = "Family"
    case health = "Health"
    case careerMoney = "Career & Money"
    
    func categoryPrompt() -> String {
        switch self {
        case .general:
            return "Provide general insights."
        case .love:
            return "Give a detailed love and relationship reading."
        case .family:
            return "Provide insights focusing on family matters and relationships."
        case .health:
            return "Give a health and well-being reading."
        case .careerMoney:
            return "Provide career and financial insights."
        }
    }

    var imageName: String {
        switch self {
        case .general:
            "sparkles"
        case .love:
            "heart"
        case .family:
            "house"
        case .health:
            "figure.dance"
        case .careerMoney:
            "dollarsign"
        }
    }
}
