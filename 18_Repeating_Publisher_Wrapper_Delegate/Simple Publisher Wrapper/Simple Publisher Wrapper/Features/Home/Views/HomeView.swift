//
//  HomeView.swift
//  Simple Publisher Wrapper
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import SnapKit
import SwiftUI
import UIKit

final class HomeView: UIView {
    // MARK: Properties
    private var oneSwitchHandler: ((Bool) -> Void)?
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

    private lazy var oneHStackView: UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        
        return vw
    }()
    
    private lazy var oneTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.borderStyle = .roundedRect
        
        return tf
    }()

    private lazy var twoTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private lazy var oneSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sw.addTarget(self, action: #selector(didChangeOneSwitch(_:)), for: .valueChanged)
        
        return sw
    }()

    
    private lazy var oneLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lb.text = "Core Location Status"
        lb.font = .preferredFont(forTextStyle: .headline)
        lb.numberOfLines = 0
        
        return lb
    }()
    
    private lazy var twoLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lb.text = "Permission Status"
        lb.font = .preferredFont(forTextStyle: .headline)
        lb.numberOfLines = 0
        
        return lb
    }()
    
    private lazy var oneButton: UIButton = {
        let bt = UIButton(type: .roundedRect)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bt.setTitle("Request Permissions", for: .normal)
        bt.setImage(.init(systemName: "lock.open.fill"), for: .normal)
        bt.setPreferredSymbolConfiguration(.init(font: .preferredFont(forTextStyle: .headline)), forImageIn: .normal)
        bt.backgroundColor = .systemGray5
        bt.layer.cornerRadius = 15.0
        bt.layer.shadowRadius = 3.0
        bt.layer.shadowOpacity = 0.3
        bt.layer.rasterizationScale = UIScreen.main.scale
        bt.layer.shouldRasterize = true
        bt.centerTextAndImage(spacing: 5.0)
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
    func setOneTextFieldText(with text: String) -> Void {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.oneTextField.text = text
        }
    }
    
    func setOneSwitchHandler(action: @escaping (Bool) -> Void) -> Void {
        oneSwitchHandler = action
    }
    
    func setTwoTextFieldText(with text: String) -> Void {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.twoTextField.text = text
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
        
        oneVStackView.addArrangedSubview(oneLabel)
        oneVStackView.setCustomSpacing(10.0, after: oneLabel)
        oneVStackView.addArrangedSubview(oneHStackView)
        oneVStackView.setCustomSpacing(50.0, after: oneHStackView)
        oneVStackView.addArrangedSubview(twoLabel)
        oneVStackView.setCustomSpacing(10.0, after: twoLabel)
        oneVStackView.addArrangedSubview(twoTextField)
        oneVStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        oneLabel.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
        }
        
        oneHStackView.addArrangedSubview(oneTextField)
        oneHStackView.setCustomSpacing(10.0, after: oneTextField)
        oneHStackView.addArrangedSubview(oneSwitch)
        
        oneTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.65)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
        }
        
        twoTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(UIScreen.main.bounds.height * 0.05)
        }
        
        oneButton.snp.makeConstraints { make in
            make.top.equalTo(oneVStackView.snp.bottom).inset(-UIScreen.main.bounds.width * 0.2)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
            make.height.equalTo(44.0)
        }
    }
    
    @objc
    private func didChangeOneSwitch(_ sender: UISwitch) -> Void {
        oneSwitchHandler?(sender.isOn)
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
