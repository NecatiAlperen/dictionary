//
//  WordSynonym.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

struct Synonym: Decodable, Comparable {
    let word: String
    let score: Int

    static func < (lhs: Synonym, rhs: Synonym) -> Bool {
        return lhs.score > rhs.score
    }
}





