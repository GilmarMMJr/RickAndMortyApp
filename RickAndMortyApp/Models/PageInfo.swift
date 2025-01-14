//
//  PageInfo.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 08/01/25.
//

import Foundation

public struct PageInfo: Codable {
    public let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
