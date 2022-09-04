//
//  BlackJackStruct.swift
//  BlackJack
//
//  Created by 羅以捷 on 2022/9/2.
//

import Foundation

typealias pokerCard = (suit: String, rank: String)
typealias pokerCount = (point: Int, cards: [(suit: String, rank: String)])


struct BlackJack {
    private var cards : [pokerCard] = []
    private let suits : [String] = ["♠️","♥️","♦️","♣️"]
    private let ranks : [String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    private let blackJackPoints : Dictionary = ["A":11, "2":2, "3":3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, "10":10, "K":10, "Q":10, "J":10]
    var playerCards : pokerCount = (0, [])
    var bankerCards : pokerCount = (0, [])
    
    func addPokerCards() -> [pokerCard] {
        var pokerCards : [pokerCard] = []
        for suit in BlackJack().suits {
            for rank in BlackJack().ranks {
                pokerCards.append((suit, rank))
            }
        }
        return pokerCards
    }

    func countCardsPoint(to currentCards: pokerCount = (0, []), _ newCard: pokerCard) -> pokerCount {
        let newCards = currentCards.cards + [newCard]
        let newPoints = self.countCardsPoint(newCards)
        return (newPoints, newCards)
    }
    
    private func countCardsPoint(_ pokerCardPoint : [pokerCard]) -> Int {
        var cardsPoints = pokerCardPoint.reduce(0) { $0 + blackJackPoints[$1.rank]! }
        let aceCards = pokerCardPoint.filter { $0.rank == "A" }
        for _ in aceCards {
            if cardsPoints > 21 {
                cardsPoints -= 10
            }
        }
        return cardsPoints
    }
}
