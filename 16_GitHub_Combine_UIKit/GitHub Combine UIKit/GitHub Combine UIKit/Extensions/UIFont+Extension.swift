//
//  UIFont+Extension.swift
//  Football Chants
//
//  Created by Bambang Tri Rahmat Doni on 13/12/23.
//

import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
    
    func rounded() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    func monospaced() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.monospaced) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
    
    func serif() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.serif) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
