//
//  WordDetail.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//


import Foundation

struct WordDetail: Decodable {
    let word: String?
    let phonetics: [Phonetic]?
    let meanings: [Meaning]?
}

struct Phonetic: Decodable {
    let text: String?
    let audio: String?
}

struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]?
}

struct Definition: Decodable {
    let definition: String?
    let example: String?
}

