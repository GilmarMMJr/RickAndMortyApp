//
//  CharacterService.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 11/02/25.
//

import Foundation
import Combine
import SDKNetwork

protocol APIServiceProtocol {
    func fetchCharacters() -> AnyPublisher<[Character], Error>
}

class CharacterService: APIServiceProtocol {
    private let provider: NetworkProviderProtocol

    init(provider: NetworkProviderProtocol = NetworkProvider()) {
        self.provider = provider
    }

    func fetchCharacters() -> AnyPublisher<[Character], Error> {
        let url = "https://rickandmortyapi.com/api/character"
        let headers = ["Content-Type": "application/json"]
        let body: Data? = nil
        let queryParams = [String: String]()
        let method = "GET"

        return Future<[Character], Error> { [weak self] promise in
            self?.provider.request(url: url,
                                   headers: headers,
                                   body: body,
                                   queryParams: queryParams,
                                   method: method) { (result: Result<CharacterResponse, Error>) in
                switch result {
                case .success(let response):
                    promise(.success(response.results))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main) // Atualiza na main thread
        .eraseToAnyPublisher() // Converte para AnyPublisher
    }
}

