//
//  Roll.swift
//  DiceRoll
//
//  Created by Dante Cesa on 3/3/22.
//

import Foundation

struct Roll: Identifiable, Codable {
    var id: UUID = UUID()
    let sides: Int
    let dateTime: Date
}
