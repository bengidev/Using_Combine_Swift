//
//  HomeView.swift
//  Simple Form
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import SnapKit
import SwiftUI
import UIKit

final class HomeView: UIView {
    // MARK: Properties
    private var oneButtonHandler: (() -> Void)?
    
    // MARK: ViewComponents
    private lazy var containerView: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return vw
    }()

    private lazy var oneVStackView: UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        
        return vw
    }()

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sb.searchBarStyle = .prominent
        sb.backgroundImage = .init()
        sb.placeholder = "Enter your favorite"
        
        return sb
    }()

    private lazy var oneTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.placeholder = "Enter first value"
        tf.borderStyle = .roundedRect
        
        return tf
    }()

    private lazy var twoTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.placeholder = "Enter second value"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private lazy var twoMirrorTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.placeholder = "Enter second value"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private lazy var oneLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lb.text = "First value"
        lb.font = .preferredFont(forTextStyle: .title2)
        
        return lb
    }()
    
    private lazy var twoLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lb.text = "Second value"
        lb.font = .preferredFont(forTextStyle: .title2)
        
        return lb
    }()
    
    private lazy var oneButton: UIButton = {
        let bt = UIButton(type: .roundedRect)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Verify", for: .normal)
        bt.setImage(.init(systemName: "checkmark"), for: .normal)
        bt.setPreferredSymbolConfiguration(.init(font: .preferredFont(forTextStyle: .headline)), forImageIn: .normal)
        bt.backgroundColor = .systemGray5
        bt.layer.cornerRadius = 15.0
        bt.layer.shadowRadius = 3.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.rasterizationScale = UIScreen.main.scale
        bt.layer.shouldRasterize = true
        bt.addTarget(self, action: #selector(didTapOneButton(_:)), for: .primaryActionTriggered)
        
        return bt
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("awakeFromNib() has not been implemented")
    }
    
    // MARK: Functionalities
    func setOneTextFieldDelegate(with delegate: UITextFieldDelegate) -> Void {
        oneTextField.delegate = delegate
    }
    
    func setTwoTextFieldDelegate(with delegate: UITextFieldDelegate) -> Void {
        twoTextField.delegate = delegate
    }
    
    func setTwoMirrorTextFieldDelegate(with delegate: UITextFieldDelegate) -> Void {
        twoMirrorTextField.delegate = delegate
    }
    
    func setOneLabelText(with text: String) -> Void {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.oneLabel.text = text
        }
    }
    
    func setTwoLabelText(with text: String) -> Void {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.twoLabel.text = text
        }
    }
    
    func setOneButtonHandler(action: @escaping () -> Void) -> Void {
        oneButtonHandler = action
    }
    
    private func setupViews() -> Void {
        backgroundColor = .systemGray6
        
        addSubview(containerView)
        
        containerView.addSubview(oneVStackView)
        containerView.addSubview(oneButton)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        oneVStackView.addArrangedSubview(oneTextField)
        oneVStackView.setCustomSpacing(30.0, after: oneTextField)
        oneVStackView.addArrangedSubview(twoTextField)
        oneVStackView.setCustomSpacing(10.0, after: twoTextField)
        oneVStackView.addArrangedSubview(twoMirrorTextField)
        oneVStackView.setCustomSpacing(50.0, after: twoMirrorTextField)
        oneVStackView.addArrangedSubview(oneLabel)
        oneVStackView.setCustomSpacing(20.0, after: oneLabel)
        oneVStackView.addArrangedSubview(twoLabel)
        oneVStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        oneTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
        
        twoTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
        
        twoMirrorTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
        
        oneButton.snp.makeConstraints { make in
            make.top.equalTo(oneVStackView.snp.bottom).inset(-UIScreen.main.bounds.width * 0.25)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
            make.height.equalTo(44.0)
        }
    }
    
    @objc
    private func didTapOneButton(_ sender: UIButton) -> Void {
        oneButtonHandler?()
    }
}

#if DEBUG
@available(iOS 13, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview(HomeView())
    }
}
#endif
