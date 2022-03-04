//
//  ContentView.swift
//  DiceRoll
//
//  Created by Dante Cesa on 3/3/22.
//

import SwiftUI

struct ContentView: View {
    @State var currentRoll: Roll?
    @State var rolls: [Roll] = []

    @State var selectedDiceSidesIndex: Int = 1
    let possibleDiceSides: [Int] = [4, 6, 8, 10, 12, 20, 100]
    
    let fileManager = FileManager()
    
    var body: some View {
        GeometryReader { fullscreen in
            NavigationView {
                VStack {
                    List {
                        Picker("🎲 number of sides", selection: $selectedDiceSidesIndex) {
                            ForEach(0..<possibleDiceSides.count) { index in
                                Text(String(possibleDiceSides[index]))
                            }
                        }
                        NavigationLink("🎲 roll history") {
                            RollHistoryView(rolls: $rolls)
                        }
                    }
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 50, height: 50)
                        .overlay {
                            if let currentRoll = currentRoll {
                                Text(String(currentRoll.sides))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: fullscreen.size.width, height: fullscreen.size.height * (0.5))
                        .onTapGesture{
                            rollDice(forSides: possibleDiceSides[selectedDiceSidesIndex])
                        }
                    
                    Button("Roll the 🎲!") {
                        rollDice(forSides: possibleDiceSides[selectedDiceSidesIndex])
                    }
                    .buttonStyle(.borderedProminent)
                }
                .navigationTitle("DiceRoll")
            }
        }
        .onAppear(perform: loadRolls)
    }
    
    func rollDice(forSides: Int) {
        let newRoll = Roll(sides: Int.random(in: 1...forSides), dateTime: Date.now)
        
        currentRoll = newRoll
        rolls.append(newRoll)
        saveRolls()
    }
    
    func loadRolls() {
        rolls = fileManager.loadRolls()
    }
    
    func saveRolls() {
        fileManager.saveRolls(rolls)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(rolls: [Roll(sides: 5, dateTime: Date.now)])
    }
}
