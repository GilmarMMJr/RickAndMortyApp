//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 21/01/25.
//

import Foundation
import SDKNetwork
import Combine

class CharacterListViewModel {
    private let service: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var isLoading: Bool = false
    @Published var characters: [Character] = []
    @Published var errorMessage: String?

    init(service: APIServiceProtocol = CharacterService()) {
        self.service = service
    }

    func fetchCharacters() {
        isLoading = true
        let parameters = CharacterRequestFactory.allCharacters()
        
        service.fetchCharacters(with: parameters)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] characters in
                self?.characters = characters
            })
            .store(in: &cancellables)
    }
}

