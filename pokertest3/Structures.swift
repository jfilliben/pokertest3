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
    
    func continueGame() -> Bool {
        return table.continueHand()
    }
    
    func returnPlayerCard (playerNum: Int, cardNum: Int) -> String {
        return table.returnPlayerCard(playerNum, cardNum: cardNum)
    }
    
    func returnPlayerStack (playerNum: Int) -> NSDecimalNumber { return table.returnPlayerStack(playerNum) }
    
    func returnPlayerName (playerNum: Int) -> String { return table.returnPlayerName(playerNum) }
    
    func returnPlayerImage (playerNum: Int) -> String { return table.returnPlayerImage(playerNum) }
    
    func returnPlayerBetAmount (playerNum: Int) -> NSDecimalNumber { return table.returnPlayerBetAmount(playerNum) }
    
    func returnPlayerInHand (playerNum: Int) -> Bool { return table.playerInHand(playerNum) }
    
    func returnTableLog () -> String { return table.tableLog }
    
    func returnPotSize () -> NSDecimalNumber { return table.returnPotSize() }
    
    func returnHandRound () -> HandRound { return table.returnHandRound() }
    
    func returnBoardCard (cardNum: Int) -> String { return table.returnBoardCard(cardNum) }
    
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
    }
}

// Player Class //

class Player {
    var name: String
    var image = "player1"
    var stackSize: NSDecimalNumber
    var betAmountRound: NSDecimalNumber = 0.00
    var dealtCards: [Card] = [Card(rank: Rank.Ace, suit: Suit.Spades), Card(rank: Rank.Ace, suit: Suit.Spades)]
    
    init(name: String, stackSize: NSDecimalNumber) {
        self.name = name
        self.stackSize = stackSize
    }
    
    func handReset() {
//empty for now
    }
    
}

class ComputerPlayer: Player {
    //    var logicAlgorithm : () -> PlayerAction()
    var tiltFactor = 0
    var attemptCheckRaise = false
    let takeAction: (Int, RoundState) -> PlayerAction

    override func handReset() {
        super.handReset()
        attemptCheckRaise = false
    }
    
    init(name: String, stackSize: NSDecimalNumber, takeAction: (Int, RoundState) -> PlayerAction) {
        self.takeAction = takeAction
        super.init(name: name, stackSize: stackSize)
    }
}

class HumanPlayer: Player {
    //    var x = true
}

class PlayerClass {
    var user = HumanPlayer(       name: "Jeremy",  stackSize: 200.00)
    var players = [ComputerPlayer]()

    init() {
        players.append(ComputerPlayer(name: "Alice", stackSize: 100.00, alwaysFold))
        players.append(ComputerPlayer(name: "Bob",   stackSize: 90.00, alwaysFold))
        players.append(ComputerPlayer(name: "Carl",  stackSize: 80.00, alwaysFold))
        players.append(ComputerPlayer(name: "Dawn",  stackSize: 70.00, alwaysCall))
        players.append(ComputerPlayer(name: "Edwin", stackSize: 60.00, alwaysCall))
        user.image = "player2"
    }

    func returnPlayerName(playerNum: Int) -> String {
        switch playerNum {
        case 0: return user.name
        default: return players[playerNum-1].name
        }
    }
    
    func returnPlayerImage(playerNum: Int) -> String {
        switch playerNum {
        case 0: return user.image
        default: return players[playerNum-1].image
        }
    }
    
    func returnPlayerCard(playerNum: Int, cardNum: Int) -> String {
        switch playerNum {
        case 0: return (user.dealtCards[cardNum].cardImage)
        default: return (players[playerNum-1].dealtCards[cardNum].cardImage)
        }
    }

    func returnPlayerStack(playerNum: Int) -> NSDecimalNumber {
        switch playerNum {
        case 0: return user.stackSize
        default: return players[playerNum-1].stackSize
        }
    }
    
    func returnPlayerBetAmount(playerNum: Int) -> NSDecimalNumber {
        switch playerNum {
        case 0: return user.betAmountRound
        default: return players[playerNum-1].betAmountRound
        }
    }
    
    func handReset(numPlayers: Int) {
        user.handReset()
        for compPlayerNum in 0..<(numPlayers - 1) {
            players[compPlayerNum].handReset()
        }
    }
    
    func dealtCard(playerNum: Int, cardNum: Int, card: Card) {
        switch playerNum {
        case 0: user.dealtCards[cardNum] = card
        default: players[playerNum-1].dealtCards[cardNum] = card
        }
    }
    
    func takeAction(playerNum: Int, roundState: RoundState) -> PlayerAction {
        return players[playerNum-1].takeAction(playerNum, roundState)
    }

    func moneyInPot (playerNum: Int, amount: NSDecimalNumber) -> NSDecimalNumber {
        switch playerNum {
        case 0:
            if user.stackSize >= amount {
                user.stackSize -= amount
                user.betAmountRound += amount
                return amount
            } else {
                let tempBet = user.stackSize
                user.betAmountRound += tempBet
                user.stackSize = 0
                return tempBet
            }
        default:
            if players[playerNum-1].stackSize >= amount {
                players[playerNum-1].stackSize -= amount
                players[playerNum-1].betAmountRound += amount
                return amount
            } else {
                let tempBet = players[playerNum-1].stackSize
                players[playerNum-1].betAmountRound += tempBet
                players[playerNum-1].stackSize = 0
                return tempBet
            }
        }
    }
}

// Table class //

class TableState {
    let hand: HandState
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
    var cutoffPlayer: Int { get { return (buttonPlayer - 1) % numPlayers } }

    init(numPlayers: Int, numCardsPerPlayer: Int, smallBlindSize: NSDecimalNumber, bigBlindSize: NSDecimalNumber, maxBuyIn: NSDecimalNumber) {
        self.numPlayers = numPlayers
        self.numCardsPerPlayer = numCardsPerPlayer
        self.smallBlindSize = smallBlindSize
        self.bigBlindSize = bigBlindSize
        self.maxBuyIn = maxBuyIn
        buttonPlayer = 0
        hand = HandState(numPlayers: numPlayers, numCardsPerPlayer: numCardsPerPlayer, buttonPlayer: buttonPlayer)
        tableLog = "New Table\n"
        tableLog += "Blinds $\(smallBlindSize)/$\(bigBlindSize)\n"
    }
    
    func returnPlayerCard (playerNum: Int, cardNum: Int) -> String { return players.returnPlayerCard(playerNum, cardNum: cardNum) }

    func returnBoardCard (cardNum: Int) -> String { return hand.returnBoardCard(cardNum) }
    
    func returnPlayerImage (playerNum: Int) -> String { return players.returnPlayerImage(playerNum) }
    
    func returnPlayerBetAmount (playerNum: Int) -> NSDecimalNumber { return players.returnPlayerBetAmount(playerNum) }
    
    func returnPlayerName (playerNum: Int) -> String { return players.returnPlayerName(playerNum) }

    func playerInHand (playerNum: Int) -> Bool { return hand.inHand(playerNum) }
    
    func returnPlayerStack (playerNum: Int) -> NSDecimalNumber { return players.returnPlayerStack(playerNum) }
    
    func returnPotSize () -> NSDecimalNumber { return hand.roundState.potSize }
    
    func returnHandRound () -> HandRound { return hand.returnHandRound() }
    
    func startHand() {
        hand.handReset(players, buttonPlayer: buttonPlayer)
        tableLog += hand.collectBlinds(players, smallBlindPlayer: smallBlindPlayer, smallBlindSize: smallBlindSize, bigBlindPlayer: bigBlindPlayer, bigBlindSize: bigBlindSize)
        hand.deal(players)
        tableLog += "Hand #\(handsPlayed+1) dealt\n"
        tableLog += "\(numPlayers) players in hand\n"
    }
    
    func continueHand() -> Bool {
        tableLog += hand.continueHand(players)
        return hand.actionPlayer == 0
    }
    
    func endHand() {
        ++handsPlayed
        buttonPlayer = (buttonPlayer + 1) % numPlayers
    }
    
    func userBet(betAmount: NSDecimalNumber) {
        tableLog += hand.userBet(betAmount, players: players)
    }

    func userCall() {
        tableLog += hand.userCall(players)
    }

    func userRaise(raiseAmount: NSDecimalNumber) {
        tableLog += hand.userRaise(raiseAmount, players: players)
    }

    func userFold() {
        tableLog += hand.userFold(players)
    }
    
    func userCheck() {
        tableLog += hand.userCheck(players)
    }

}

// Hand class //

class HandState {
    var deck = Deck()
    var actionPlayer = 0
    var potSize: NSDecimalNumber = 0.00
    let numPlayers: Int
    let numCardsPerPlayer: Int
    let roundState: RoundState
    let buttonPlayer: Int
   
    init(numPlayers: Int, numCardsPerPlayer: Int, buttonPlayer: Int) {
        self.numPlayers = numPlayers
        self.numCardsPerPlayer = numCardsPerPlayer
        self.buttonPlayer = buttonPlayer
        roundState = RoundState(numPlayers: numPlayers, buttonPlayer: buttonPlayer)
    }

    func inHand(playerNum: Int) -> Bool { return roundState.playerInHand[playerNum] }
    
    func returnHandRound() -> HandRound { return roundState.round }
    
    func returnBoardCard(cardNum: Int) -> String { return roundState.board[cardNum-1].cardImage }
    
    func handReset(players: PlayerClass, buttonPlayer: Int) {
        potSize = 0.00
        actionPlayer = (buttonPlayer + 3) % numPlayers
        players.handReset(numPlayers)
        roundState.reset(players)
    }

    func advanceRound() {
        roundState.advanceRound(deck)
        actionPlayer = (buttonPlayer + 1) % numPlayers
    }

    func continueHand(players: PlayerClass) -> String {
        var tableLog: String = ""
        if (roundState.playerStacks[actionPlayer] > 0) && roundState.playerInHand[actionPlayer] {
            let playerAction = players.takeAction(actionPlayer, roundState: roundState)
            tableLog += roundState.updateRound(actionPlayer, playerAction: playerAction, players: players)
        }
        potSize = roundState.potSize
        if actionPlayer == roundState.lastToAct
        {
            self.advanceRound()
        } else {
            actionPlayer = (actionPlayer + 1) % numPlayers
        }
        return tableLog
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
            roundState.playerMoneyInPot[smallBlindPlayer] = smallBlind
            tableLog += "\(players.returnPlayerName(smallBlindPlayer)) chips in small blind of $\(smallBlind)\n"
            let bigBlind = players.moneyInPot(bigBlindPlayer, amount: bigBlindSize)
            potSize += bigBlind
            roundState.playerMoneyInPot[bigBlindPlayer] = bigBlind
            tableLog += "\(players.returnPlayerName(bigBlindPlayer)) chips in big blind of $\(bigBlind)\n"
            tableLog += "Pot size is now $\(potSize)\n"
            actionPlayer = (bigBlindPlayer + 1) % numPlayers
            roundState.potSize = potSize
            roundState.betToCall = bigBlindSize
            return tableLog
    }
    
    func userBet(betAmount: NSDecimalNumber, players: PlayerClass) -> String {
        let tableLog = roundState.userBet(betAmount, players: players)
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }

    func userRaise(betAmount: NSDecimalNumber, players: PlayerClass) -> String {
        let tableLog = roundState.userRaise(betAmount, players: players)
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }
    
    func userCall(players: PlayerClass) -> String {
        let tableLog = roundState.userCall(players)
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }

    func userFold(players: PlayerClass) -> String {
        let tableLog = roundState.userFold(players)
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }

    func userCheck(players: PlayerClass) -> String {
        let tableLog = roundState.userFold(players)
        actionPlayer = (actionPlayer + 1) % numPlayers
        return tableLog
    }
}

class RoundState {
    var round = HandRound.Preflop
    var board: [Card] = []
    var potSize: NSDecimalNumber = 0.00
    var betToCall: NSDecimalNumber = 0.00
    var straddle = false
    var playerInHand: [Bool] = []
    var playerStacks: [NSDecimalNumber] = []
    var playerActions: [PlayerAction] = []
    var playerMoneyInPot: [NSDecimalNumber] = []
    var lastToAct: Int = 0
    var roundComplete = false
    var numPlayers: Int
    var buttonPlayer: Int

    init (numPlayers: Int, buttonPlayer: Int) {
        self.numPlayers = numPlayers
        self.buttonPlayer = buttonPlayer
        for playerNum in 0..<numPlayers { playerInHand.append(true) }
        for playerNum in 0..<numPlayers { playerStacks.append(0.00) }
        for playerNum in 0..<numPlayers { playerActions.append(PlayerAction.None()) }
        for playerNum in 0..<numPlayers { playerMoneyInPot.append(0.00) }
    }
    
    func reset(players: PlayerClass) {
        round = HandRound.Preflop
        board.removeAll()
        potSize = 0.00
        betToCall = 0.00
        straddle = false
        for playerNum in 0..<numPlayers { playerInHand[playerNum] = true }
        for playerNum in 0..<numPlayers {
            playerStacks[playerNum] = players.returnPlayerStack(playerNum)
        }
        for playerNum in 0..<numPlayers { playerActions[playerNum] = PlayerAction.None() }
        for playerNum in 0..<numPlayers { playerMoneyInPot[playerNum] = 0.00 }
        lastToAct = (buttonPlayer + 2) % numPlayers
        roundComplete = false
    }

    func updateRound(actionPlayer: Int, playerAction: PlayerAction, players: PlayerClass) -> String {
        var tableLog = ""
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
            lastToAct = (actionPlayer - 1) % numPlayers
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
            lastToAct = (actionPlayer - 1) % numPlayers
            tableLog += "\(players.returnPlayerName(actionPlayer)) raises $\(raiseAmount)\n"
            tableLog += "Pot size is now $\(potSize)\n"
        case .Check:
            playerActions[actionPlayer] = playerAction
            tableLog += "\(players.returnPlayerName(actionPlayer)) checks\n"
        default: break
        }
        return tableLog
    }
    
    func advanceRound(deck: Deck) {
        // check if only one player is remaining; if so, break
        if round == .River { return }
        var numPlayersInHand = 0
        for index in 0..<numPlayers {
            if playerInHand[index] { ++numPlayersInHand }
        }
        if numPlayersInHand <= 1 { return }
        // if multiple players, advance round and reset roundState values
        round = HandRound(rawValue: (round.rawValue + 1))!
        switch round {
        case .Flop:
            board.append(deck.dealCard())
            board.append(deck.dealCard())
            board.append(deck.dealCard())
        case .Turn:
            board.append(deck.dealCard())
        case .River:
            board.append(deck.dealCard())
        default: break
        }
        lastToAct = buttonPlayer
        betToCall = 0.00
        for playerNum in 0..<numPlayers { playerActions[playerNum] = PlayerAction.None() }
        for playerNum in 0..<numPlayers { playerMoneyInPot[playerNum] = 0 }
        roundComplete = false
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
        return tableLog
    }
    
    func userCheck(players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Check()
        tableLog += "\(players.returnPlayerName(0)) checks\n"
        return tableLog
    }
    
    func userFold(players: PlayerClass) -> String {
        var tableLog = ""
        playerActions[0] = PlayerAction.Fold()
        playerInHand[0] = false
        tableLog += "\(players.returnPlayerName(0)) folds\n"
        return tableLog
    }

}
