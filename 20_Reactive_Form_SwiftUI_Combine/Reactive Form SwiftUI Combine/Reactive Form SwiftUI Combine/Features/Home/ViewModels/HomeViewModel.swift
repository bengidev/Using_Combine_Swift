//
//  HomeViewModel.swift
//  Reactive Form SwiftUI Combine
//
//  Created by Bambang Tri Rahmat Doni on 06/01/24.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var firstEntry: String = .init() { // 1
        didSet { firstEntryPublisher.send(firstEntry) }
    }
    
    @Published var secondEntry: String = .init() {
        didSet { secondEntryPublisher.send(secondEntry) }
    }
    
    @Published var validationMessages: [String] = []
    
    private(set) var submitAllowed: AnyPublisher<Bool, Never>
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private let firstEntryPublisher = CurrentValueSubject<String, Never>(.init()) // 2
    private let secondEntryPublisher = CurrentValueSubject<String, Never>(.init())
    
    init() {
        let validationPipeline = Publishers.CombineLatest(firstEntryPublisher, secondEntryPublisher) // 3
            .map { arg -> [String] in // 4
                var dialogMessages: [String] = []
                let (firstValue, secondValue) = arg
                
                if (firstValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) !=
                    secondValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                    dialogMessages.append("Values for fields must match.")
                }
                
                if (firstValue.count < 5 || secondValue.count < 5) {
                    dialogMessages.append("Please enter values for at least 5 characters.")
                }
                
                return dialogMessages
            }
        
        submitAllowed = validationPipeline // 5
            .map { stringArray in
                return stringArray.isEmpty
            }
            .eraseToAnyPublisher()
        
        let _ = validationPipeline // 6
            .sink { [weak self]  result in
                self?.validationMessages = result
            }
            .store(in: &cancellableSet)
    }
}

/// 1. The firstEntry and secondEntry properties are both set with default values of an empty string.
/// 2. These properties are then also mirrored with a currentValueSubject, which is updated using didSet
///     from each of the @Published properties. This drives the combine pipelines defined below to trigger
///     the reactive updates when the values are changed from the SwiftUI view.
/// 3. combineLatest is used to merge updates from either of firstEntry or secondEntry so that updates
///     will be triggered from either source.
/// 4. map takes the input values and uses them to determine and publish a list of validating messages.
///     This overall flow is the source for two follow on pipelines.
/// 5. The first of the follow on pipelines uses the list of validation messages to determine a true
///     or false Boolean publisher that is used to enable, or disable, the submit button.
/// 6. The second of the follow on pipelines takes the validation messages and updates them locally on this
///     ObservedObject reference for SwiftUI to watch and use as it sees fit.
///
