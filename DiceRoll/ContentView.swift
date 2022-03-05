//
//  ContentView.swift
//  DiceRoll
//
//  Created by Dante Cesa on 3/3/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State var rolls: [RollResult] = []
    @State var currentResult: RollResult = RollResult(numberOfDiceSides: 0, numberOfDice: 0, dateTime: .now, rolls: [])
    @State var stoppedDice: Int = 0
    let timer = Timer.publish(every: 0.1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]
    
    let possibleDiceSides: [Int] = [4, 6, 8, 10, 12, 20, 100]
    @AppStorage("selectedDiceSidesIndex") var selectedDiceSides: Int = 6
    @AppStorage("numberOfDice") var numberOfDice: Int = 4
    
    let fileManager = FileManager()
    let feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    var body: some View {
        GeometryReader { fullscreen in
            NavigationView {
                VStack {
                    Form {
                        Section {
                            Picker("🎲 number of sides", selection: $selectedDiceSides) {
                                ForEach(possibleDiceSides, id:\.self) { diceSide in
                                    Text("D\(diceSide)")
//                                        .accessibilityLabel(diceSide)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Stepper("Number of 🎲: \(numberOfDice)", value: $numberOfDice, in: 1...20)
                                .accessibilityLabel("Number of dice")
                                .accessibilityValue("\(numberOfDice)")
                            
                            Button("Let's roll!") {
                                rollDice(forDiceSides: selectedDiceSides, andNumberOfDice: numberOfDice)
                            }
                        } header: {
                            Text("Configure roll")
                                .accessibility(hidden: true)
                        } footer: {
                            if currentResult.rolls.isEmpty == false && rolls.isEmpty == false {
                                LazyVGrid(columns: columns) {
                                    ForEach(0..<currentResult.rolls.count, id:\.self) { index in
                                        Text(String(currentResult.rolls[index]))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .background(.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .font(.title)
                                            .padding(5)
                                    }
                                }
                                .accessibilityElement()
                                .accessibilityLabel("Result is: \(currentResult.description)")
                            }
                        }
                    }
                }
                .disabled(stoppedDice < currentResult.rolls.count)
                .navigationTitle("🎲 DiceRoll")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if rolls.isEmpty == false {
                            NavigationLink("Roll History") {
                                RollHistoryView(rolls: $rolls)
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadRolls)
        .onReceive(timer) { date in
            updateDice()
        }
    }
    
    func rollDice(forDiceSides: Int, andNumberOfDice dice: Int) {
        var currentRolls: [Int] = []
        
        for _ in 0..<numberOfDice {
            currentRolls.append(Int.random(in: 1...forDiceSides))
        }
        
        let newRollResult = RollResult(numberOfDiceSides: selectedDiceSides, numberOfDice: numberOfDice, dateTime: Date.now, rolls: currentRolls)
        
        currentResult = newRollResult
        rolls.insert(newRollResult, at: 0)
        saveRolls()
        
        if voiceOverEnabled {
            stoppedDice = numberOfDice
        } else {
            stoppedDice = -20
        }
    }
    
    func updateDice() {
        guard stoppedDice < currentResult.rolls.count else { return }
        
        for i in stoppedDice..<numberOfDice {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1...selectedDiceSides)
            feedback.impactOccurred()
        }
        
        stoppedDice += 1
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
        ContentView()
    }
}
