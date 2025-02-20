//
//  CardView.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 19.02.25.
//

import SwiftUI
import Foundation

enum TarotCard: String, CaseIterable, Identifiable {

    case theFool = "The Fool"
    case theMagician = "The Magician"
    case theHighPriestess = "The High Priestess"
    case theEmpress = "The Empress"
    case theEmperor = "The Emperor"
    case theHierophant = "The Hierophant"
    case theLovers = "The Lovers"
    case theChariot = "The Chariot"
    case strength = "Strength"
    case theHermit = "The Hermit"
    case wheelOfFortune = "Wheel of Fortune"
    case justice = "Justice"
    case theHangedMan = "The Hanged Man"
    case death = "Death"
    case temperance = "Temperance"
    case theDevil = "The Devil"
    case theTower = "The Tower"
    case theStar = "The Star"
    case theMoon = "The Moon"
    case theSun = "The Sun"
    case judgement = "Judgement"
    case theWorld = "The World"

    // Get a random tarot card
    static func drawRandomCard() -> TarotCard {
        return Self.allCases.randomElement()!
    }

    var suit: String {
        rawValue.lowercased().replacingOccurrences(of: " ", with: "-")
    }

    var id: String {
        rawValue
    }

}


struct CardSlot: View {

    let title: String
    let card: TarotCard?
    let isPopped: Bool
    let onTap: () -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .bold()
                .foregroundColor(.gray)

            if let card = card {
                TarotCardView(card: card, isFlipped: true, isPopped: isPopped)
                    .onTapGesture {
                        onTap()
                    }
                    //.transition(.scale.combined(with: .opacity))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 160)
            }
        }
    }
}

struct TarotCardView: View {

    let card: TarotCard
    var isFlipped: Bool
    var isPopped: Bool

    var body: some View {
        ZStack {
            if isFlipped {
                VStack {
                    Image(card.suit)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(12)
                        .frame(width: 100, height: 160)
                        .shadow(radius: 5)
                        .animation(.easeInOut(duration: 0.3), value: isPopped)
                        .transition(.slide)
                    Text(card.rawValue)
                        .font(.callout)
                        .foregroundStyle(Color.white)
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color.purple, Color.black], startPoint: .top, endPoint: .bottom))
                    .frame(width: 100, height: 160)
                    .overlay(content: {
                        Image("taro-closed")
                    })
                    .shadow(radius: 5)
                    .transition(.slide)
            }
        }
    }
}
