//
//  CharacterRequestFactory.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 08/03/25.
//

import Foundation

struct CharacterRequestFactory {
    static func allCharacters() -> RequestParameters {
        return RequestParameters(url: "https://rickandmortyapi.com/api/character",
                                 headers: ["Content-Type": "application/json"],
                                 body: nil,
                                 queryParams: [String: String](),
                                 method: "GET")
    }
}
