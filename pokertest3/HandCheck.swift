//
//  HandCheck.swift
//  pokertest3
//
//  Created by Jeremy Filliben on 12/31/14.
//  Copyright (c) 2014 Jeremy Filliben. All rights reserved.
//

import Foundation

func bestFive(hand1: [Card]) -> ([Card], String) {
    /* takes an array of Cards (at least five)
    and returns ana Array of Cards containing the best possible
    hand that can be made from the original collection of cards
    and returns a String which is a text description of the best
    hand type found
    */
    let currentBest: [Card] = []
    let currentBestString = ""
    return (currentBest, currentBestString)
}

func isHand1Better(hand1: [Card], hand2: [Card]) -> (Bool, Bool) {
    /* Passed two Arrays of 5 cards, sorted by rank
       Returns (True, X) if hand1 is better
       Returns (False, True) if hands are equal
       Returns (False, False) if hand2 is better
    */

    func higherCard(hand1: [Card], hand2: [Card]) -> (Bool, Bool) {
        /* Returns (True, X) if hand1 is better
        Returns (False, True) if hands are equal
        Returns (False, False) if hand2 is better
        */

        return (true, true)
    }
    
    func isFlush(handToCheck: [Card]) -> Bool {
        if (handToCheck[0].suit == handToCheck[1].suit) &&
        (handToCheck[0].suit == handToCheck[2].suit) &&
        (handToCheck[0].suit == handToCheck[3].suit) &&
        (handToCheck[0].suit == handToCheck[4].suit) {
            return true }
        return false
    }
    
    func isStraight(handToCheck: [Card]) -> Bool {
        // first deal with generic straights (no Ace-low)
        if handToCheck[0].rank.rawValue == (handToCheck[1].rank.rawValue - 1) && handToCheck[0].rank.rawValue == (handToCheck[3].rank.rawValue - 2) && handToCheck[0].rank.rawValue == (handToCheck[3].rank.rawValue - 3) && handToCheck[0].rank.rawValue == (handToCheck[4].rank.rawValue - 4) {
            return true
        }
        // next deal with Ace-low straights specifically
        if handToCheck[0].rank == Rank.Ace && handToCheck[1].rank == Rank.Two && handToCheck[2].rank == Rank.Three && handToCheck[3].rank == Rank.Four && handToCheck[4].rank == Rank.Five {
            return true
        }
        return false
    }
    
    func isStraightFlush(handToCheck: [Card]) -> Bool {
        if isStraight(handToCheck) && isFlush(handToCheck) { return true }
        else { return false }
    }
 
    return (true, true)
}

