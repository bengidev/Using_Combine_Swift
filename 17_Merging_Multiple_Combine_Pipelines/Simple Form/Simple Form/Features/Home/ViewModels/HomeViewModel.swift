//
//  HomeViewModel.swift
//  Simple Form
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import Combine
import UIKit

final class HomeViewModel: NSObject {
    @Published private(set) var oneLabelValue: String = .init()
    @Published private(set) var twoLabelValue: String = .init()
    @Published private(set) var twoMirrorLabelValue: String = .init()
    
    func setOneLabelValue(with value: String) -> Void {
        oneLabelValue = value
    }
    
    func setTwoLabelValue(with value: String) -> Void {
        twoLabelValue = value
    }
    
    func setTwoMirrorLabelValue(with value: String) -> Void {
        twoMirrorLabelValue = value
    }
    
    func validateOneLabelValue() -> AnyPublisher<String?, Never> {
        //
        
        return Empty().eraseToAnyPublisher()
    }
}
