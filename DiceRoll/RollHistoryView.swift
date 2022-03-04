//
//  rollHistoryView.swift
//  DiceRoll
//
//  Created by Dante Cesa on 3/3/22.
//

import SwiftUI

struct RollHistoryView: View {
    @Binding var rolls: [Roll]
    
    var body: some View {
        List {
            ForEach(rolls) { roll in
                VStack(alignment: .leading) {
                    Text(String(roll.sides))
                    Text(roll.dateTime.formatted(date: .abbreviated, time: .shortened))
                        .foregroundColor(.secondary)
                }
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle("🎲 roll history")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Remove All") {
                    rolls.removeAll()
                }
            }
        }
    }
    
    func deleteItem(for offsets: IndexSet) {
        rolls.remove(atOffsets: offsets)
    }
}

struct rollHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RollHistoryView(rolls: .constant([Roll(sides: 4, dateTime: Date.now), Roll(sides: 6, dateTime: Date.now)]))
    }
}
