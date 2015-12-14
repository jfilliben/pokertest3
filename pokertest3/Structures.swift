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

enum HandStatus {
    case NoBet, BetPlaced, BetMoreThanStack, PlayerFolded, HandComplete
}

enum ButtonPressed {
    case Deal, Bet(NSDecimalNumber), Raise(NSDecimalNumber), Call, Fold, Check
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
    
    func reset() {
        deck.removeAll()
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
        for i in Array((1 ... (deck.count - 1)).reverse()) {
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
    case Raise(NSDecimalNumber)
    case Bet(NSDecimalNumber)
    case Call(NSDecimalNumber)
    case Check()
    case Fold()
    case None()
}

class GameState {
    let numCardsPerPlayer = 2
    let numPlayers = 6
    var table: TableState
    
    init() {
        table = TableState(numPlayers: numPlayers, numCardsPerPlayer: numCardsPerPlayer, smallBlindSize: 1.00, bigBlindSize: 2.00, maxBuyIn: 200.00)
    }
    
    func startGame() {
        // empty for now
    }
    
    func continueGame() {
        table.continueHand()
        if self.returnHandStatus() == .HandComplete {
            table.endHand()
        }
    }
    
    func returnHandStatus() -> HandStatus {
        return table.returnHandStatus()
    }
    
    func returnPlayerCardImage(playerNum: Int, cardNum: Int) -> String {
        return table.returnPlayerCardImage(playerNum, cardNum: cardNum)
    }
    
    func isUserTurn() -> Bool { return table.isUserTurn() }
    
    func returnPlayerStack(playerNum: Int) -> NSDecimalNumber { return table.returnPlayerStack(playerNum) }
    
    func returnPlayerName(playerNum: Int) -> String { return table.returnPlayerName(playerNum) }
    
    func returnPlayerImage(playerNum: Int) -> String { return table.returnPlayerImage(playerNum) }
    
    func returnPlayerBetAmount(playerNum: Int) -> NSDecimalNumber { return table.returnPlayerBetAmount(playerNum) }
    
    func returnPlayerInHand(playerNum: Int) -> Bool { return table.playerInHand(playerNum) }
    
    func returnTableLog() -> String { return table.tableLog }
    
    func returnPotSize() -> NSDecimalNumber { return table.returnPotSize() }
    
    func returnHandRound() -> HandRound { return table.returnHandRound() }
    
    func returnBoardCardImage(cardNum: Int) -> String { return table.returnBoardCardImage(cardNum) }
    
    func buttonPressed(button: ButtonPressed) {
        switch button {
        case .Deal:
            table.startHand()
        case .Bet(let betAmount):
            table.userBet(betAmount)
        case .Raise(let raiseAmount):
            table.userRaise(raiseAmount)
        case .Call:
            table.userCall()
        case .Check:
            table.userCheck()
        case .Fold:
            table.userFold()
        }
        if self.returnHandStatus() == .HandComplete {
            table.endHand()
        }
    }
}

// Table class //

class TableState {
    var hand: HandState
    let numPlayers: Int
    let numCardsPerPlayer: Int
    var tableLog = ""
    let smallBlindSize, bigBlindSize, maxBuyIn : NSDecimalNumber
    var handsPlayed = 0
    let players = PlayerClass()
    // user starts out as button, for now
    var buttonPlayer: Int
    var smallBlindPlayer: Int { get { return (buttonPlayer + 1) % numPlayers } }
    var bigBlindPlayer: Int { get { return (buttonPlayer + 2) % numPlayers } }
    var UTGPlayer: Int { get { return (buttonPlayer + 3) % numPlayers } }
    var cutoffPlayer: Int { get { return (buttonPlayer + numPlayers - 1) % numPlayers } }

    init(numPlayers: Int, numCardsPerPlayer: Int, smallBlindSize: NSDecimalNumber, bigBlindSize: NSDecimalNumber, maxBuyIn: NSDecimalNumber) {
        self.numPlayers = numPlayers
        self.numCardsPerPlayer = numCardsPerPlayer
        self.smallBlindSize = smallBlindSize
        self.bigBlindSize = bigBlindSize
        self.maxBuyIn = maxBuyIn
        buttonPlayer = 0
        hand = HandState(numPlayers: numPlayers, numCardsPerPlayer: numCardsPerPlayer, buttonPlayer: buttonPlayer, players: players)
        tableLog = "New Table\n"
        tableLog += "Blinds $\(smallBlindSize)/$\(bigBlindSize)\n"
    }
    
    func returnHandStatus() -> HandStatus { return hand.returnHandStatus(players) }
    
    func isUserTurn() -> Bool { return hand.isUserTurn() }
    
    func returnPlayerImage(playerNum: Int) -> String { return players.returnPlayerImage(playerNum) }
    
    func returnPlayerBetAmount(playerNum: Int) -> NSDecimalNumber { return players.returnPlayerBetAmount(playerNum) }
    
    func returnPlayerName(playerNum: Int) -> String { return players.returnPlayerName(playerNum) }
    
    func returnPlayerStack(playerNum: Int) -> NSDecimalNumber { return players.returnPlayerStack(playerNum) }
    
    func returnPlayerCardImage(playerNum: Int, cardNum: Int) -> String { return players.returnPlayerCardImage(playerNum, cardNum: cardNum) }

    func returnBoardCardImage(cardNum: Int) -> String { return hand.returnBoardCardImage(cardNum) }
    
    func playerInHand(playerNum: Int) -> Bool { return hand.inHand(playerNum) }
    
    func returnPotSize() -> NSDecimalNumber { return hand.returnPotSize() }
    
    func returnHandRound() -> HandRound { return hand.returnHandRound() }
    
    func startHand() {
        hand = HandState(numPlayers: numPlayers, numCardsPerPlayer: numCardsPerPlayer, buttonPlayer: buttonPlayer, players: players)
        tableLog += hand.collectBlinds(players, smallBlindPlayer: smallBlindPlayer, smallBlindSize: smallBlindSize, bigBlindPlayer: bigBlindPlayer, bigBlindSize: bigBlindSize)
        hand.deal(players)
        tableLog += "Hand #\(handsPlayed+1) dealt\n"
        tableLog += "\(numPlayers) players in hand\n"
    }
    
    func continueHand() {
        tableLog += hand.continueHand(players)
    }
    
    func endHand() {
        ++handsPlayed
        buttonPlayer = (buttonPlayer + 1) % numPlayers
    }
    
    func userBet(betAmount: NSDecimalNumber) {
        tableLog += hand.userBet(betAmount, players: players)
    }

    func userCall() { tableLog += hand.userCall(players) }

    func userRaise(raiseAmount: NSDecimalNumber) {
        tableLog += hand.userRaise(raiseAmount, players: players)
    }

    func userFold() { tableLog += hand.userFold(players) }
    
    func userCheck() { tableLog += hand.userCheck(players) }
}

// Hand class //

class HandState {
    var deck = Deck()
    var board: [Card] = []
    var potSize: NSDecimalNumber = 0.00
    let numPlayers: Int
    let numCardsPerPlayer: Int
    var straddle = false
    var playerStacks: [NSDecimalNumber] = []
    var playerMoneyInPot: [NSDecimalNumber] = []
    var playerInHand: [Bool] = []
    var playerActions: [PlayerAction] = []
    let buttonPlayer: Int
    var lastToAct: Int
    var actionPlayer: Int
    var numPlayersInHand: Int
    var currentRound = HandRound.Preflop
    var handComplete = false
    var betToCall: NSDecimalNumber = 0.00
    
    init(numPlayers: Int, numCardsPerPlayer: Int, buttonPlayer: Int, players: PlayerClass) {
        self.numPlayers = numPlayers
        self.numPlayersInHand = numPlayers
        self.numCardsPerPlayer = numCardsPerPlayer
        self.buttonPlayer = buttonPlayer
        self.lastToAct = (buttonPlayer + 2) % numPlayers
        self.actionPlayer = (buttonPlayer + 3) % numPlayers
        for playerNum in 0..<numPlayers {
            playerStacks.append(players.returnPlayerStack(playerNum))
            playerMoneyInPot.append(0.00)
            playerInHand.append(true)
            playerActions.append(PlayerAction.None())
        }
    }

    func isUserTurn() -> Bool { return actionPlayer == 0 }
    
    func inHand(playerNum: Int) -> Bool { return playerInHand[playerNum] }
    
    func returnPotSize() -> NSDecimalNumber { return potSize }
    
    func returnHandStatus(players: PlayerClass) -> HandStatus {
        // Used to determine buttons to display in ViewController
        if handComplete { return .HandComplete }
        if !playerInHand[0] { return .PlayerFolded }
        if betToCall > players.returnPlayerStack(0) {
            return .BetMoreThanStack
        }
        if betToCall == 0 {
            return .NoBet
        } else {
            return .BetPlaced
        }
    }

    func returnHandRound() -> HandRound { return currentRound }
    
    func returnBoardCardImage(cardNum: Int) -> String { return board[cardNum-1].cardImage }
    
    func continueHand(players: PlayerClass) -> String {
        //needs work
        // need an indication of 'end-of-round'
        var tableLog = ""
        if playerInHand[actionPlayer] && playerStacks[actionPlayer] > 0.00 {
            let playerAction = players.takeAction(actionPlayer, handState: self)
            switch playerAction {
            case .Fold:
                playerActions[actionPlayer] = playerAction
                playerInHand[actionPlayer] = false
                tableLog += "\(players.returnPlayerName(actionPlayer)) folds\n"
            case .Bet(let betAmount):
                playerActions[actionPlayer] = playerAction
                players.moneyInPot(actionPlayer, amount: betAmount)
                potSize += betAmount
                betToCall = betAmount
                playerMoneyInPot[actionPlayer] = betAmount
                lastToAct = (actionPlayer + numPlayers - 1) % numPlayers
                tableLog += "\(players.returnPlayerName(actionPlayer)) bets $\(betAmount)\n"
                tableLog += "Pot size is now $\(potSize)\n"
            case .Call(let callAmount):
                playerActions[actionPlayer] = playerAction
                players.moneyInPot(actionPlayer, amount: callAmount)
                potSize += callAmount
                playerMoneyInPot[actionPlayer] += callAmount
                tableLog += "\(players.returnPlayerName(actionPlayer)) calls $\(callAmount)\n"
                tableLog += "Pot size is now $\(potSize)\n"
            case .Raise(let raiseAmount):
                playerActions[actionPlayer] = playerAction
                players.moneyInPot(actionPlayer, amount: raiseAmount)
                potSize += raiseAmount
                playerMoneyInPot[actionPlayer] += raiseAmount
                lastToAct = (actionPlayer + numPlayers - 1) % numPlayers
                tableLog += "\(players.returnPlayerName(actionPlayer)) raises $\(raiseAmount)\n"
                tableLog += "Pot size is now $\(potSize)\n"
            case .Check:
                playerActions[actionPlayer] = playerAction
                tableLog += "\(players.returnPlayerName(actionPlayer)) checks\n"
            default: break
            }
        }
        if actionPlayer == lastToAct
        {
            tableLog += self.advanceRound(players)
        } else {
            actionPlayer = (actionPlayer + 1) % numPlayers
        }
        return tableLog
    }
    
    func advanceRound(players: PlayerClass) -> String {
        var tableLog = ""
        if (currentRound == .River) || (numPlayersInHand == 1) {
            tableLog += self.completeHand(players)
            handComplete = true
            return tableLog
        }
        currentRound = HandRound(rawValue: (currentRound.rawValue + 1))!
        lastToAct = buttonPlayer
        actionPlayer = (buttonPlayer + 1) % numPlayers
        betToCall = 0.00
        for playerNum in 0..<numPlayers {
            playerMoneyInPot[playerNum] = 0
            if playerInHand[playerNum] { playerActions[playerNum] = PlayerAction.None() }
            else { playerActions[playerNum] = PlayerAction.Fold() }
        }
        switch currentRound {
        case .Flop:
            tableLog += "Flop is "
            board.append(deck.dealCard())
            tableLog += "\(board[0].cardImage) "
            board.append(deck.dealCard())
            tableLog += "\(board[1].cardImage) "
            board.append(deck.dealCard())
            tableLog += "\(board[2].cardImage)\n"
        case .Turn:
            tableLog += "Turn card is "
            board.append(deck.dealCard())
            tableLog += "\(board[3].cardImage)\n"
        case .River:
            tableLog += "River card is "
            board.append(deck.dealCard())
            tableLog += "\(board[4].cardImage)\n"
        default: break
        }
        return tableLog
        }

    func completeHand(players: PlayerClass) -> String {
//needs work
        var winningPlayer = 0
        var tableLog = ""
        if numPlayersInHand == 1 {
            while !playerInHand[winningPlayer] { ++winningPlayer }
        } else {
            var playerHands: [(Int, Card, Card)] = []
            for playerNum in 0..<numPlayers {
                if playerInHand[playerNum] {
                    playerHands.append((playerNum, players.returnPlayerCard(playerNum, cardNum: 0), players.returnPlayerCard(playerNum, cardNum: 1)))
                }
            }
            winningPlayer = compareHands(playerHands)
            }
        players.completeHand(winningPlayer, potSize: potSize)
        tableLog += "\(players.returnPlayerName(winningPlayer)) wins $\(potSize)\n"
        return tableLog
    }

    func compareHands(playerHands: [(Int, Card, Card)]) -> Int {
        var tempPlayerHands = playerHands
        var bestHand = tempPlayerHands.removeLast()
        while tempPlayerHands.count > 0 {
            let nextHand = tempPlayerHands.removeLast()
            if betterHand(nextHand, hand2: bestHand) {
                bestHand = nextHand
            }
        }
        let (winningPlayer, _, _) = bestHand
        return winningPlayer
    }
    
    func betterHand(hand1: (Int, Card, Card), hand2: (Int, Card, Card)) -> Bool {
        // needs work
        return true
    }
    
    func deal(players: PlayerClass) {
        deck.shuffle()
        for cardNum in 0..<numCardsPerPlayer {
            for playerNum in 0..<numPlayers {
                players.dealtCard(playerNum, cardNum: cardNum, card: deck.dealCard())
            }
        }
    }
    
    func collectBlinds(players: PlayerClass, smallBlindPlayer: Int, smallBlindSize: NSDecimalNumber, bigBlindPlayer: Int, bigBlindSize: NSDecimalNumber) -> String {
             var tableLog: String = ""
            let smallBlind = players.moneyInPot(smallBlindPlayer, amount: smallBlindSize)
            potSize += smallBlind
            playerMoneyInPot[smallBlindPlayer] = smallBlind
            tableLog += "\(players.returnPlayerName(smallBlindPlayer)) chips in small blind of $\(smallBlind)\n"
            let bigBlind = players.moneyInPot(bigBlindPlayer, amount: bigBlindSize)
            potSize += bigBlind
            playerMoneyInPot[bigBlindPlayer] = bigBlind
            tableLog += "\(players.returnPlayerName(bigBlindPlayer)) chips in big blind of $\(bigBlind)\n"
            tableLog += "Pot size is now $\(potSize)\n"
            actionPlayer = (bigBlindPlayer + 1) % numPlayers
            betToCall = bigBlindSize
            return tableLog
    }
    
    func userBet(betAmount: NSDecimalNumber, players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Bet(betAmount)
        players.moneyInPot(0, amount: betAmount)
        potSize += betAmount
        betToCall = betAmount
        playerMoneyInPot[0] = betAmount
        lastToAct = numPlayers - 1
        tableLog += "\(players.returnPlayerName(0)) bets $\(betAmount)\n"
        tableLog += "Pot size is now $\(potSize)\n"
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }
    
    func userCall(players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Call(betToCall)
        let callAmount = players.moneyInPot(0, amount: betToCall)
        potSize += callAmount
        playerMoneyInPot[0] = callAmount
        tableLog += "\(players.returnPlayerName(0)) calls $\(callAmount)\n"
        tableLog += "Pot size is now $\(potSize)\n"
        if actionPlayer == lastToAct
        {
            tableLog += self.advanceRound(players)
        } else {
            actionPlayer = (actionPlayer + 1) % numPlayers
        }
        return tableLog
    }
    
    func userRaise(raiseAmount: NSDecimalNumber, players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Raise(raiseAmount)
        players.moneyInPot(0, amount: betToCall)
        players.moneyInPot(0, amount: raiseAmount)
        betToCall += raiseAmount
        potSize += betToCall
        playerMoneyInPot[0] += betToCall
        lastToAct = numPlayers - 1
        tableLog += "\(players.returnPlayerName(0)) raises to $\(raiseAmount)\n"
        tableLog += "Pot size is now $\(potSize)\n"
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }
    
    func userCheck(players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Check()
        tableLog += "\(players.returnPlayerName(0)) checks\n"
       if actionPlayer == lastToAct
        {
            tableLog += self.advanceRound(players)
        } else {
            actionPlayer = (actionPlayer + 1) % numPlayers
        }
        return tableLog
    }
    
    func userFold(players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Fold()
        playerInHand[0] = false
        tableLog += "\(players.returnPlayerName(0)) folds\n"
        if actionPlayer == lastToAct
        {
            tableLog += self.advanceRound(players)
        } else {
            actionPlayer = (actionPlayer + 1) % numPlayers
        }
        return tableLog
    }
}
