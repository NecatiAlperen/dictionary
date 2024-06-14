//
//  NetworkService.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 9.06.2024.
//

import Foundation
import Alamofire

final class NetworkService {

    static let shared = NetworkService()

    private init() {}

    func fetchWordDetails(word: String, completion: @escaping (Result<[WordDetail], Error>) -> Void) {
        let url = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        AF.request(url).validate().responseDecodable(of: [WordDetail].self) { response in
            switch response.result {
            case .success(let wordDetails):
                completion(.success(wordDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSynonyms(word: String, completion: @escaping (Result<[Synonym], Error>) -> Void) {
        let url = "https://api.datamuse.com/words?rel_syn=\(word)"
        AF.request(url).validate().responseDecodable(of: [Synonym].self) { response in
            switch response.result {
            case .success(let synonyms):
                completion(.success(synonyms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}









