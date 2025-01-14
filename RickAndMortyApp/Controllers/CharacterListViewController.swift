//
//  CharacterListViewController.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 08/01/25.
//

import UIKit
import SDKNetwork

class CharacterListViewController: UIViewController {
    // MARK: - Properties
    private let provider: NetworkProviderProtocol = NetworkProvider()
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCharacters()
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

    // MARK: - Network Request
    private func fetchCharacters() {
        let url = "https://rickandmortyapi.com/api/character"
        let headers = ["Content-Type": "application/json"]
        let body: Data? = nil
        let queryParams = [String: String]()
        let method = "GET"

        showLoading(true)

        provider.request(url: url,
                         headers: headers,
                         body: body,
                         queryParams: queryParams,
                         method: method) { [weak self] (result: Result<CharacterResponse, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showLoading(false)
                switch result {
                case .success(let response):
                    self.characters = response.results
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showError(message: error.localizedDescription)
                }
            }
        }
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
}

// MARK: - CharacterCell
class CharacterCell: UITableViewCell {
    static let identifier = "CharacterCell"

    func configure(with character: Character) {
        textLabel?.text = character.name
        detailTextLabel?.text = character.species
    }
}
