//
//  HomeViewModel.swift
//  Simple Form
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import Combine
import UIKit

final class HomeViewModel: NSObject {
    @Published private(set) var oneTextFieldValue: String = .init()
    @Published private(set) var twoTextFieldValue: String = .init()
    @Published private(set) var twoMirrorTextFieldValue: String = .init()
    
    func setOneTextFieldValue(with value: String) -> Void {
        oneTextFieldValue = value
    }
    
    func setTwoTextFieldValue(with value: String) -> Void {
        twoTextFieldValue = value
    }
    
    func setTwoMirrorTextFieldValue(with value: String) -> Void {
        twoMirrorTextFieldValue = value
    }
    
    func validateOneTextFieldValue(message: @escaping (String?) -> Void) -> AnyPublisher<String?, Never> { // 2
        return $oneTextFieldValue.map { oneValue -> String? in
            guard oneValue.count > 2 else {
                DispatchQueue.main.async { message("Minimum of 3 characters required") } // 3
                return nil
            }
            
            DispatchQueue.main.async { message("") }
            return oneValue
        }
        .eraseToAnyPublisher()
    }
    
    func validateTwoTextFieldLabelValue(message: @escaping (String?) -> Void) -> AnyPublisher<String?, Never> { // 4
        return Publishers.CombineLatest($twoTextFieldValue, $twoMirrorTextFieldValue)
            .receive(on: DispatchQueue.main) // 5
            .map { twoValue, twoMirrorValue  in
                guard twoValue == twoMirrorValue,  twoValue.count > 4 else {
                    DispatchQueue.main.async { message("Values must match and have at least 5 characters") }
                    return nil
                }
                
                DispatchQueue.main.async { message("") }
                return twoValue
            }
            .eraseToAnyPublisher()
    }
    
    func validateToSubmit(
        publisherOne: AnyPublisher<String?, Never>,
        publisherTwo: AnyPublisher<String?, Never>
    ) -> AnyPublisher<(String, String)?, Never> { // 6
        return Publishers.CombineLatest(publisherOne, publisherTwo)
            .map { valueOne, valueTwo in
                guard let realValueOne = valueOne, let realValueTwo = valueTwo else {
                    return nil
                }
                
                return (realValueOne, realValueTwo)
            }
            .eraseToAnyPublisher()
    }
}
