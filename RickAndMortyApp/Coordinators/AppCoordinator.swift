//
//  AppCoordinator.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 08/01/25.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    // MARK: - Properties
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    // MARK: - Methods
    func start() {
        showCharacterList()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showCharacterList() {
        let viewController = CharacterListViewController()
        navigationController.viewControllers = [viewController]
    }
    
}
