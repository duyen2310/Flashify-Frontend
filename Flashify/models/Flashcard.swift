//
//  Flashcard.swift
//  Flashify
//
//  Created by Ky Duyen on 5/4/25.
//

struct Flashcard: Identifiable, Codable {
    let id: Int
    let question: String
    let answer: String
    let folderId: String
}
