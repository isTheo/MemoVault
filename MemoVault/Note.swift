//
//  Note.swift
//  MemoVault
//
//  Created by Matteo Orru on 22/05/24.
//

import Foundation

struct Note: Codable {
    var text: String
    var date: Date
    var attributedText: Data? // Per salvare il testo formattato
    
    init(text: String, date: Date = Date(), attributedText: Data? = nil) {
        self.text = text
        self.date = date
        self.attributedText = attributedText
    }
}
