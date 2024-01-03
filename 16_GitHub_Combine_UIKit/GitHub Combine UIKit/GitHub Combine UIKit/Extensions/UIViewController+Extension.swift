//
//  UIViewController+Extension.swift
//  Alpha Todo
//
//  Created by Bambang Tri Rahmat Doni on 19/12/23.
//

import UIKit

extension UIViewController {
    /// When you extract child view controller from a parent, there are three things you need to do
    /// in order to include that child view controller in the parent's view controller life cycle.
    /// 
    /// First, add the view of the child to the view of the parent.
    /// Then, add the child to the parent.
    /// Finally, notify the child that it was moved to a parent.
    ///
    /// - Parameter child: Another UIViewController which will be the child.
    ///
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// Remove the child UIViewController from parent UIViewController if available.
    ///
    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
