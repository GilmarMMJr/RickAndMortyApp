//
//  CharacterListViewController.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 08/01/25.
//

import UIKit
import Combine

class CharacterListViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CharacterListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var characters: [Character] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchCharacters()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Rick and Morty Characters"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Bind ViewModel
    private func setupBindings() {
        // Observa mudanças no isLoading e exibe ou oculta o indicador de carregamento
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                self?.showLoading(isLoading)
            }
            .store(in: &cancellables)
        
        // Observa mudanças nos personagens e recarrega a tabela
        viewModel.$characters
            .sink { [weak self] characters in
                self?.characters = characters
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Observa mudanças na mensagem de erro e exibe um alerta
        viewModel.$errorMessage
            .compactMap { $0 } // Remove valores nulos
            .sink { [weak self] message in
                self?.showError(message: message)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helpers
    private func showLoading(_ show: Bool) {
        activityIndicator.isHidden = !show
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
