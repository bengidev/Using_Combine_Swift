//
//  UIScreen+Extension.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import UIKit

extension UIScreen {
    static var width: CGFloat {
        return self.main.bounds.width
    }
    
    static var height: CGFloat {
        return self.main.bounds.height
    }
}
