//
//  Structures.swift
//  pokertest2
//
//  Created by Jeremy Filliben on 12/16/14.
//  Copyright (c) 2014 Jeremy Filliben. All rights reserved.
//

import Foundation

enum HandRound : Int {
    case Preflop = 0, Flop, Turn, River
}

enum ButtonPressed : Int {
    case Deal = 0, Bet, Raise, Call, Fold, Check
}

enum Rank : Int {
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace
}
enum Suit : Int {
    case Clubs = 0, Diamonds, Hearts, Spades
}

struct Card {
    let rank: Rank
    let suit: Suit
    var cardImage: String {
        get {
            var tempCardImage = ""
            switch rank {
            case .Two:   tempCardImage += "2"
            case .Three: tempCardImage += "3"
            case .Four:  tempCardImage += "4"
            case .Five:  tempCardImage += "5"
            case .Six:   tempCardImage += "6"
            case .Seven: tempCardImage += "7"
            case .Eight: tempCardImage += "8"
            case .Nine:  tempCardImage += "9"
            case .Ten:   tempCardImage += "T"
            case .Jack:  tempCardImage += "J"
            case .Queen: tempCardImage += "Q"
            case .King:  tempCardImage += "K"
            case .Ace:   tempCardImage += "A"
            }
            switch suit {
            case .Clubs:    tempCardImage += "c"
            case .Diamonds: tempCardImage += "d"
            case .Hearts:   tempCardImage += "h"
            case .Spades:   tempCardImage += "s"
            }
            return tempCardImage
        }
    }
}

class Deck {
    var deck: [Card] = []
    
    init () {
        var n = 2
        while let rank = Rank(rawValue: n) {
            var m = 0
            while let suit = Suit(rawValue: m) {
                deck.append(Card(rank: rank, suit: suit))
                m++
            }
            n++
        }
    }
    
    func shuffle() {
        var tempDeck = deck
        for i in reverse(1 ... (deck.count - 1)) {
            let rndNum = Int(arc4random_uniform(UInt32(i)))
            swap(&tempDeck[i], &tempDeck[rndNum])
        }
        deck = tempDeck
    }
    
    func dealCard() -> Card {
        return deck.removeAtIndex(0)
    }
    
}

enum PlayerAction {
    case Bet(Float)
    case Fold()
    case Check()
    case Raise(Float)
    case Call(Float)
    case CheckRaise()
}

class Player {
    var name: String
    var image = "player1"
    var stackSize: Float
    var betAmountRound: Float = 0.00
    var inHand = true
    var dealtCards: [Card] = [Card(rank: Rank.Ace, suit: Suit.Spades), Card(rank: Rank.Ace, suit: Suit.Spades)]
    init(name: String, stackSize: Float) {
        self.name = name
        self.stackSize = stackSize
    }
}

class ComputerPlayer: Player {
    //    var logicAlgorithm : () -> PlayerAction()
    var tiltFactor = 0
    var attemptCheckRaise = false

    func takeAction (potSize: Float, handRound: HandRound, board: [Card], playerNum :Int) -> PlayerAction {
        inHand = false
        return PlayerAction.Fold()
    }

}

class HumanPlayer: Player {
    //    var x = true
}

class PlayerClass {
    var user = HumanPlayer(       name: "Jeremy",  stackSize: 123.00)
    var players = [ComputerPlayer]()

    init() {
        players.append(ComputerPlayer(name: "Alice",   stackSize: 100.00))
        players.append(ComputerPlayer(name: "Bob",     stackSize: 90.00))
        players.append(ComputerPlayer(name: "Carl",    stackSize: 80.00))
        players.append(ComputerPlayer(name: "Dierdra", stackSize: 70.00))
        players.append(ComputerPlayer(name: "Edwin",   stackSize: 60.00))
        user.image = "player2"
    }
    
    func bet (playerNum: Int, betAmount: Float) -> Float {
        switch playerNum {
        case 0:
            if user.stackSize >= betAmount {
                user.stackSize -= betAmount
                user.betAmountRound += betAmount
                return betAmount
            } else {
                let tempBet = user.stackSize
                user.betAmountRound += tempBet
                user.stackSize = 0
                return tempBet
            }
        default:
            if players[playerNum-1].stackSize >= betAmount {
                players[playerNum-1].stackSize -= betAmount
                players[playerNum-1].betAmountRound += betAmount
                return betAmount
            } else {
                let tempBet = players[playerNum-1].stackSize
                players[playerNum-1].betAmountRound += tempBet
                players[playerNum-1].stackSize = 0
                return tempBet
            }
        }
    }

}

class GameState {
    let numCardsPerPlayer = 2
    let numPlayers = 6
    var table = TableState(smallBlindSize: 1.00, bigBlindSize: 2.00, maxBuyIn: 100.00, minBet: 2.00)
    
    init() {
        table = TableState(smallBlindSize: 1.00, bigBlindSize: 2.00, maxBuyIn: 100.00, minBet: 2.00)
    }
    
    func startGame() {
// empty for now
    }
    
    func returnCard (playerNum: Int, cardNum: Int) -> String {
        switch playerNum {
        case 0: return (table.players.user.dealtCards[cardNum].cardImage)
        default: return (table.players.players[playerNum-1].dealtCards[cardNum].cardImage)
        }
    }
    
    func returnPlayerStack (playerNum: Int) -> Float {
        switch playerNum {
        case 0: return table.players.user.stackSize
        default: return table.players.players[playerNum-1].stackSize
        }
    }
    
    func returnPlayerName (playerNum: Int) -> String {
        switch playerNum {
        case 0: return table.players.user.name
        default: return table.players.players[playerNum-1].name
        }
    }

    func returnPlayerImage (playerNum: Int) -> String {
        switch playerNum {
        case 0: return table.players.user.image
        default: return table.players.players[playerNum-1].image
        }
    }
    
    func returnPlayerBetAmount (playerNum: Int) -> Float {
        switch playerNum {
        case 0: return table.players.user.betAmountRound
        default: return table.players.players[playerNum-1].betAmountRound
        }
    }
    
    func returnPlayerInHand (playerNum: Int) -> Bool {
        switch playerNum {
        case 0: return table.players.user.inHand
        default: return table.players.players[playerNum-1].inHand
        }
    }
    
    func returnPotSize () -> Float {
        return table.hand.potSize
    }
    
    func buttonPressed(button: ButtonPressed) {
        switch button {
        case .Deal:
            table.startHand()
            table.continueHand()
        case .Bet:
            break
        case .Raise:
            break
        case .Call:
            break
        case .Fold:
            break
        case .Check:
            break
        }
    }
}

class TableState {
    var hand = HandState()
    let smallBlindSize, bigBlindSize, maxBuyIn, minBet : Float
    let numPlayers = 6
    var handsPlayed = 0
    let numCardsPerPlayer = 2
    var players = PlayerClass()
    var buttonPlayer = 0
    var smallBlindPlayer: Int {
        get {
            return (buttonPlayer + 1) % numPlayers
        }
    }
    var bigBlindPlayer: Int {
        get {
            return (buttonPlayer + 2) % numPlayers
        }
    }
    var UTGPlayer: Int {
        get {
            return (buttonPlayer + 3) % numPlayers
        }
    }
    var cutoffPlayer: Int {
        get {
            return (buttonPlayer - 1) % numPlayers
        }
    }
    // user starts out as button, for now
    
    init(smallBlindSize : Float, bigBlindSize : Float, maxBuyIn : Float, minBet : Float) {
        self.smallBlindSize = smallBlindSize
        self.bigBlindSize = bigBlindSize
        self.maxBuyIn = maxBuyIn
        self.minBet = minBet
        buttonPlayer = 0
    }
    
    func startHand() {
        hand.handReset(numPlayers, buttonPlayer: buttonPlayer)
        hand.collectBlinds(players, smallBlindPlayer: smallBlindPlayer, smallBlindSize: smallBlindSize, bigBlindPlayer: bigBlindPlayer, bigBlindSize: bigBlindSize, numPlayers: numPlayers)
        hand.deal(players, numCardsPerPlayer: numCardsPerPlayer, numPlayers: numPlayers)
    }
    
    func continueHand() {
        hand.playerAction(players, numPlayers: numPlayers)
    }
    
    func endHand() {
        ++handsPlayed
        buttonPlayer = (buttonPlayer + 1) % numPlayers
    }
}


class HandState {
    var potSize : Float = 0.00
    var handRound: HandRound = .Preflop
    var board = [Card]()
    var straddle = false
    var numPlayersInHand = 0
    var deck = Deck()
    var actionPlayer = 0
   
    init() {
// empty init
    }
    
    func handReset(numPlayers: Int, buttonPlayer: Int) {
        potSize = 0.00
        handRound = .Preflop
        board.removeAll()
        straddle = false
        numPlayersInHand = numPlayers
        actionPlayer = (buttonPlayer + 3) % numPlayers
    }
    
    func deal(players: PlayerClass, numCardsPerPlayer: Int, numPlayers: Int) {
        deck.shuffle()
        for cardNum in 0..<numCardsPerPlayer {
            players.user.dealtCards[cardNum] = deck.dealCard()
            for playerNum in 0..<(numPlayers - 1) {
                players.players[playerNum].dealtCards[cardNum] = deck.dealCard()
            }
        }
        for cardNum in 0..<5 {
            board.append(deck.dealCard())
        }
    }
    
    func collectBlinds(players: PlayerClass, smallBlindPlayer: Int, smallBlindSize: Float, bigBlindPlayer: Int, bigBlindSize: Float, numPlayers: Int) {
        potSize += players.bet(bigBlindPlayer, betAmount: bigBlindSize)
        potSize += players.bet(smallBlindPlayer, betAmount: smallBlindSize)
        actionPlayer = (bigBlindPlayer + 1) % numPlayers
    }
    
    func playerAction(players: PlayerClass, numPlayers: Int) {
        while actionPlayer != 0 {
            players.players[actionPlayer-1].takeAction(potSize, handRound: handRound, board: board, playerNum: actionPlayer)
            actionPlayer = (actionPlayer + 1) % numPlayers
        }
    }
}
