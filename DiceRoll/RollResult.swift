//
//  Roll.swift
//  DiceRoll
//
//  Created by Dante Cesa on 3/3/22.
//

import Foundation

struct RollResult: Identifiable, Codable {
    var id: UUID = UUID()
    let numberOfDiceSides: Int
    let numberOfDice: Int
    let dateTime: Date
    var rolls: [Int]
    
    var description: String {
        rolls.map(String.init).joined(separator: ", ")
    }
}
