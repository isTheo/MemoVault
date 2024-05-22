//
//  Note.swift
//  MemoVault
//
//  Created by Matteo Orru on 22/05/24.
//

import Foundation


struct Note: Codable {
    var id: UUID = UUID()
    var title: String = "New note"
    var content: String = ""
    var creationDate: Date = Date.now
    
    var hasContent: Bool {
        return !content.isEmpty
    }
    
}
