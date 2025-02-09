//
//  Bindable.swift
//  RickAndMortyApp
//
//  Created by Gilmar Manoel de Mendonça Junior on 21/01/25.
//

import Foundation
import Combine

@propertyWrapper
class Bindable<T> {
    private var subject: CurrentValueSubject<T, Never>
    
    var wrappedValue: T {
        get { subject.value }
        set { subject.send(newValue) }
    }
    
    var projectedValue: AnyPublisher<T, Never> {
        subject.eraseToAnyPublisher()
    }
    
    init(wrappedValue: T) {
        subject = CurrentValueSubject(wrappedValue)
    }
}
