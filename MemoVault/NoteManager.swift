//
//  NoteManager.swift
//  MemoVault
//
//  Created by Matteo Orru on 26/05/24.
//



import Foundation

class NoteManager {
    static let shared = NoteManager()
    
    private let notesKey = "notes"
    
    private init() {}
    
    func loadNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: notesKey),
              let savedNotes = try? JSONDecoder().decode([Note].self, from: data) else {
            return []
        }
        return savedNotes
    }
    
    func saveNotes(_ notes: [Note]) {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: notesKey)
        }
    }
    
    
    
}

