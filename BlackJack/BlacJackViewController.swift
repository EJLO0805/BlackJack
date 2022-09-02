//
//  ViewController.swift
//  BlackJack
//
//  Created by 羅以捷 on 2022/9/2.
//

import UIKit

class BlackJackViewController: UIViewController {

    override func viewDidLoad() {
        showResultTextView.layer.cornerRadius = 20
        bankerCardsLabel.layer.masksToBounds = true
        bankerCardsLabel.layer.cornerRadius = 20
        playerCardsLabel.layer.masksToBounds = true
        playerCardsLabel.layer.cornerRadius = 20
        pokerCards = pokerCards.shuffled()
        showResultTextView.text = "請開始"
        // Do any additional setup after loading the view.
    }
    var pokerCards = BlackJack().addPokerCards().shuffled()
    var playerCards = BlackJack().playerCards
    var bankerCards = BlackJack().bankerCards
    var cardIndex = 2
    
    @IBOutlet weak var showResultTextView: UITextView!
    @IBOutlet weak var playerCardsLabel: UILabel!
    @IBOutlet weak var bankerCardsLabel: UILabel!
    @IBOutlet weak var playerDealCards: UIButton!
    @IBOutlet weak var changeToBanker: UIButton!

    @IBAction func replayButton(_ sender: Any) {
        playerCards = (0,[])
        bankerCards = (0,[])
        cardIndex = 2
        pokerCards = pokerCards.shuffled()
        showResultTextView.text = "新的一局，請開始"
        playerCardsLabel.text = "PlayerCards"
        bankerCardsLabel.text = "BankerCards"
        changeToBanker.isEnabled = true
        playerDealCards.isEnabled = true
    }
    @IBAction func dealCardsButton(_ sender: UIButton) {
        if playerCards.point == 0 {
            playerCards =  BlackJack().countCardsPoint(pokerCards[0])
            bankerCards = BlackJack().countCardsPoint(pokerCards[1])
            bankerCardsLabel.text = "🂠"
        }else {
            playerCards = BlackJack().countCardsPoint(to: playerCards, pokerCards[cardIndex])
            cardIndex += 1
        }
        switch playerCards.point {
            case ..<21 :
                showResultTextView.text = showResultTextView.text  + "\n玩家 \(playerCards.point) 點，是否要補牌"
            case 21 :
                showResultTextView.text = showResultTextView.text  + "\n玩家21點，莊家\(bankerCards.point)點\n玩家獲勝"
                bankerCardsLabel.text = "\(bankerCards.cards.map { $0.suit + $0.rank }.joined(separator:"\n"))"
                sender.isEnabled = false
                changeToBanker.isEnabled = false
            case 22...:
                showResultTextView.text = showResultTextView.text  + "\n玩家\(playerCards.point)點爆掉，莊家\(bankerCards.point)\n莊家獲勝"
                bankerCardsLabel.text = "\(bankerCards.cards.map { $0.suit + $0.rank }.joined(separator:"\n"))"
                sender.isEnabled = false
                changeToBanker.isEnabled = false
            default : break
        }
        playerCardsLabel.text = "\(playerCards.cards.map { $0.suit + $0.rank }.joined(separator:"\n"))"
    }
    
    
    @IBAction func playerStopDealCardButton(_ sender: UIButton) {
        playerDealCards.isEnabled = false
        bankerCardsLabel.text = "\(bankerCards.cards)"
        while bankerCards.cards.count < 5 && bankerCards.point < playerCards.point {
            bankerCards = BlackJack().countCardsPoint(to: bankerCards, pokerCards[cardIndex])
            bankerCardsLabel.text = "\(bankerCards.cards.map { $0.suit + $0.rank }.joined(separator:"\n"))"
            cardIndex += 1
            showResultTextView.text = showResultTextView.text + "\n莊家 \(bankerCards.point) 點"
        }
        sender.isEnabled = false
        switch (playerCards.point, bankerCards.point) {
            case (_, 22...) :
                showResultTextView.text = showResultTextView.text + "\n玩家\(playerCards.point)點爆掉，莊家\(bankerCards.point)\n玩家獲勝"
            case (_, ..<21) where bankerCards.cards.count == 5 :
                showResultTextView.text = showResultTextView.text + "莊家5張牌\n莊家獲勝"
            case(let playerPoint, let  bankerPoint) :
                var winner : String
                if playerPoint == bankerPoint {
                    winner = "\n平手"
                } else {
                    winner = "\n玩家\(playerCards.point)點，莊家\(bankerCards.point)點\n\(bankerPoint > playerPoint ? "莊家" : "玩家") 獲勝"
                }
                showResultTextView.text = showResultTextView.text + winner
            default : break
        }
    }
}

