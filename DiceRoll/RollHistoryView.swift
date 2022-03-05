//
//  rollHistoryView.swift
//  DiceRoll
//
//  Created by Dante Cesa on 3/3/22.
//

import SwiftUI

struct RollHistoryView: View {
    @Binding var rolls: [RollResult]
    
    var body: some View {
        List {
            ForEach(rolls) { rollResult in
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(rollResult.description)
                                .bold()
                            Text("\(rollResult.dateTime.formatted(date: .abbreviated, time: .shortened))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Text("\(String(rollResult.numberOfDice)) x D\(String(rollResult.numberOfDiceSides))")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .background(.white)
                            .foregroundColor(.black)
                            .shadow(radius: 10)
                            .clipShape(Capsule())
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(String(rollResult.numberOfDice)) D\(String(rollResult.numberOfDiceSides)), Results: \(rollResult.description)")
                }
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle("🎲 Roll History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Remove All") {
                    rolls.removeAll()
                    let manager = FileManager()
                    
                    manager.saveRolls(rolls)
                }
                .disabled(rolls.isEmpty == true)
            }
        }
    }
    
    func deleteItem(for offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }
}

struct rollHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RollHistoryView(rolls: .constant([RollResult(numberOfDiceSides: 6, numberOfDice: 4, dateTime: .now, rolls: [6,4])]))
    }
}
