//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 21/01/25.
//

import Foundation
import SDKNetwork

class CharacterListViewModel {
    private let provider: NetworkProviderProtocol
    private var characters: [Character] = []
    
    var onCharactersUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    init(provider: NetworkProviderProtocol = NetworkProvider()) {
        self.provider = provider
    }
    
    func fetchCharacters() {
        let url = "https://rickandmortyapi.com/api/character"
        let headers = ["Content-Type": "application/json"]
        
        onLoadingStateChanged?(true)
        
        provider.request(url: url,
                         headers: headers,
                         body: nil,
                         queryParams: [:],
                         method: "GET") { [weak self] (result: Result<CharacterResponse, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.onLoadingStateChanged?(false)
                switch result {
                case .success(let response):
                    self.characters = response.results
                    self.onCharactersUpdated?()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func numberOfCharacters() -> Int {
        return characters.count
    }
    
    func character(at index: Int) -> Character {
         return characters[index]
    }
}
