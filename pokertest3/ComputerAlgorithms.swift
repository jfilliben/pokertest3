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
    return PlayerAction.Fold()
}

func alwaysCall(playerNum: Int, roundState: RoundState) -> PlayerAction {
    if roundState.betToCall == 0.00 { return PlayerAction.Check() }
    let proposedCall = roundState.betToCall-roundState.playerMoneyInPot[playerNum]
    if proposedCall > roundState.playerStacks[playerNum] {
        return PlayerAction.Call(roundState.playerStacks[playerNum])
    }
    return PlayerAction.Call(proposedCall)
}