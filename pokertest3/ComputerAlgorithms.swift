//
//  ComputerAlgorithms.swift
//  pokertest3
//
//  Created by Jeremy Filliben on 12/23/14.
//  Copyright (c) 2014 Jeremy Filliben. All rights reserved.
//

// Algorithms to determine computer player actions

import Foundation

func alwaysFold(playerNum: Int, roundState: RoundState) -> PlayerAction {
    if roundState.betToCall - roundState.playerMoneyInPot[playerNum] == 0 {
        return PlayerAction.Check()
    } else {
    return PlayerAction.Fold()
    }
}

func alwaysCall(playerNum: Int, roundState: RoundState) -> PlayerAction {
    if roundState.betToCall == 0.00 { return PlayerAction.Check() }
    let proposedCall = roundState.betToCall-roundState.playerMoneyInPot[playerNum]
    if proposedCall > roundState.playerStacks[playerNum] {
        return PlayerAction.Call(roundState.playerStacks[playerNum])
    }
    return PlayerAction.Call(proposedCall)
}


// Player Classes

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
    
    func returnPlayerCardImage(playerNum: Int, cardNum: Int) -> String {
        switch playerNum {
        case 0: return (user.dealtCards[cardNum].cardImage)
        default: return (players[playerNum-1].dealtCards[cardNum].cardImage)
        }
    }
    
    func returnPlayerCard(playerNum: Int, cardNum: Int) -> Card {
        switch playerNum {
        case 0: return (user.dealtCards[cardNum])
        default: return (players[playerNum-1].dealtCards[cardNum])
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
    
    func completeHand(winningPlayer: Int, potSize: NSDecimalNumber) {
        switch winningPlayer {
        case 0:
            user.stackSize += potSize
        default:
            players[winningPlayer-1].stackSize += potSize
        }
    }
}
