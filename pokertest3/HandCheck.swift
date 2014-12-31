//
//  HandCheck.swift
//  pokertest3
//
//  Created by Jeremy Filliben on 12/31/14.
//  Copyright (c) 2014 Jeremy Filliben. All rights reserved.
//

import Foundation

func isFlush(handToCheck: [Card]) -> Bool {
    return false
}

func isStraight(handToCheck: [Card]) -> Bool {
    return false
}

func isStraightFlush(handToCheck: [Card]) -> Bool {
    if isStraight(handToCheck) && isFlush(handToCheck) { return true }
    else { return false }
}

