//
//  CharacterRequest.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 07/03/25.
//

import Foundation

struct RequestParameters {
    let url: String
    let headers: [String: String]
    let body: Data?
    let queryParams: [String: String]
    let method: String
    
    init(url: String, 
         headers: [String : String],
         body: Data?,
         queryParams: [String : String],
         method: String) {
        self.url = url
        self.headers = headers
        self.body = body
        self.queryParams = queryParams
        self.method = method
    }
}



