//
//  AppFactoryView.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 03/01/24.
//

import UIKit

final class AppFactoryView: NSObject {
    private override init() {
        super.init()
    }
    
    class func buildView() -> UIView {
        let vw = UIView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return vw
    }
    
    class func buildImageTextButton(
        with font: UIFont = .preferredFont(forTextStyle: .headline),
        isImageOnRight: Bool = false
    ) -> UIButton {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.titleLabel?.font = .preferredFont(forTextStyle: .headline).rounded()
        bt.titleLabel?.textAlignment = .center
        bt.tintColor = .label
        bt.backgroundColor = .systemBlue
        bt.layer.cornerRadius = 15.0
        bt.semanticContentAttribute = isImageOnRight ? .forceRightToLeft : .unspecified
        bt.titleEdgeInsets.right = isImageOnRight ? 5.0 : -10.0
        bt.imageEdgeInsets.left = isImageOnRight ? 5.0 : -10.0
        
        return bt
    }
    
    class func buildTextButton(with font: UIFont = .preferredFont(forTextStyle: .headline)) -> UIButton {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.titleLabel?.font = font
        bt.titleLabel?.adjustsFontSizeToFitWidth = true
        bt.titleLabel?.textAlignment = .center
        bt.tintColor = .label
        bt.backgroundColor = .systemBlue
        bt.layer.cornerRadius = 15.0
        
        return bt
    }
    
    class func buildImageButton(with font: UIFont = .preferredFont(forTextStyle: .headline)) -> UIButton {
        let bt = UIButton(type: .system)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.tintColor = .label
        bt.backgroundColor = .systemBlue
        bt.setPreferredSymbolConfiguration(.init(font: font,scale: .default),forImageIn: .normal)
        
        return bt
    }
    
    class func buildLabel() -> UILabel {
        let lb = UILabel(frame: .zero)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lb.textAlignment = .center
        lb.textColor = .label
        lb.numberOfLines = 0
        
        return lb
    }
    
    class func buildTextView() -> UITextView {
        let vw = UITextView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.textAlignment = .center
        vw.textColor = .label
        vw.adjustsFontForContentSizeCategory = true
        vw.textContainerInset = .init(
            top: 10.0,
            left: 10.0,
            bottom: 10.0,
            right: 10.0
        )
        
        return vw
    }
    
    class func buildStackView() -> UIStackView {
        let vw = UIStackView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        
        return vw
    }
    
    class func buildTableView(with style: UITableView.Style = .plain) -> UITableView {
        let vw = UITableView(frame: .zero, style: style)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.separatorStyle = .none
        vw.rowHeight = UITableView.automaticDimension
        vw.estimatedRowHeight = UITableView.automaticDimension
        
        return vw
    }
    
    class func buildCollectionView(scrollDirection: UICollectionView.ScrollDirection = .vertical) -> UICollectionView {
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = scrollDirection
        fl.itemSize = UICollectionViewFlowLayout.automaticSize
        fl.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: fl)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return vw
    }
    
    class func buildImageView() -> UIImageView {
        let vw = UIImageView(frame: .zero)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.setContentHuggingPriority(.defaultLow, for: .vertical)
        vw.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        vw.setContentHuggingPriority(.defaultLow, for: .horizontal)
        vw.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        vw.contentMode = .scaleAspectFit
        
        return vw
    }
}




