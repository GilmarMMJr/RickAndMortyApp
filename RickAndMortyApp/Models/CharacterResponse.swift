//
//  CharacterResponse.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 08/01/25.
//

import Foundation

public struct CharacterResponse: Codable {
    public let info: PageInfo
    public let results: [Character]
}
