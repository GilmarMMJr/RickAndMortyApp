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
    func fetchCharacters(with parameters: RequestParameters) -> AnyPublisher<[Character], Error>
}

class CharacterService: APIServiceProtocol {
    private let provider: NetworkProviderProtocol

    init(provider: NetworkProviderProtocol = NetworkProvider()) {
        self.provider = provider
    }

    
    func fetchCharacters(with parameters: RequestParameters) -> AnyPublisher<[Character], Error> {
        return Future<[Character], Error> { [weak self] promise in
            self?.provider.request(url: parameters.url,
                                   headers: parameters.headers,
                                   body: parameters.body,
                                   queryParams: parameters.queryParams,
                                   method: parameters.method) { (result: Result<CharacterResponse, Error>) in
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

