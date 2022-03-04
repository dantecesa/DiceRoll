//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Dante Cesa on 2/11/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func loadRolls() -> [Roll] {
        if let data = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent("SavedRolls")) {
            if let decodedRolls = try? JSONDecoder().decode([Roll].self, from: data) {
                return decodedRolls
            }
        }
        return []
    }
    
    func saveRolls(_ rolls: [Roll]) {
        if let encodedRolls = try? JSONEncoder().encode(rolls) {
            do {
                try encodedRolls.write(to: FileManager.documentsDirectory.appendingPathComponent("SavedRolls"), options: [.atomic, .completeFileProtection])
            } catch {
                print("Couldn't save: \(error.localizedDescription)")
            }
        }
    }
}
