//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 09/02/25.
//

import UIKit

class CharacterCell: UITableViewCell {
    static let identifier = "CharacterCell"
    
    func configure(with character: Character) {
        textLabel?.text =  character.name
        detailTextLabel?.text = character.species
    }
}
