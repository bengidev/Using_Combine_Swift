//
//  HomeView.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 03/01/24.
//

import SnapKit
import SwiftUI
import UIKit

final class HomeView: UIView {
    // MARK: Properties
    private var searchTextFieldDelegate: UISearchTextFieldDelegate?
    
    // MARK: View Components
    private lazy var containerView: UIView = {
        let vw = AppFactoryView.buildView()
        
        return vw
    }()
    
    private lazy var blurEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        let vw = UIVisualEffectView(effect: blurEffect)
        vw.frame = bounds
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return vw
    }()
    
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let vw = UIActivityIndicatorView(style: .large)
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vw.startAnimating()
        
        return vw
    }()
    
    private lazy var oneVStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .vertical
        
        return vw
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let tf = UISearchTextField(frame: .zero)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tf.placeholder = "Enter github username"
        tf.font = .preferredFont(forTextStyle: .subheadline).italic().monospaced()
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private lazy var profileImageView: UIImageView = {
        let vw = AppFactoryView.buildImageView()
        vw.image = .WWDC
        vw.contentMode = .scaleAspectFill
        vw.layer.cornerRadius = 10.0
        vw.clipsToBounds = true
        
        return vw
    }()
    
    private lazy var twoVStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .vertical
        
        return vw
    }()
    
    private lazy var profileName: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Lorem Ipsum"
        lb.font = .preferredFont(forTextStyle: .largeTitle).bold().monospaced()
        
        return lb
    }()
    
    private lazy var profileUsername: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Lorem Ipsum"
        lb.font = .preferredFont(forTextStyle: .headline).italic().monospaced()
        lb.textColor = .systemGray
        
        return lb
    }()
    
    private lazy var profileBio: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Lorem Ipsum"
        lb.font = .preferredFont(forTextStyle: .title3).rounded()
        lb.textColor = .systemGray
        
        return lb
    }()
    
    private lazy var oneHStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .horizontal
        
        return vw
    }()
    
    private lazy var locationView: UIImageView = {
        let vw = AppFactoryView.buildImageView()
        vw.contentMode = .scaleAspectFit
        vw.image = .init(systemName: "location")
        vw.tintColor = .systemGray
        
        return vw
    }()
    
    private lazy var locationName: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Lorem Ipsum"
        lb.font = .preferredFont(forTextStyle: .subheadline).rounded()
        lb.textColor = .systemGray
        
        return lb
    }()
    
    private lazy var containerDetailView: UIView = {
        let vw = AppFactoryView.buildView()
        vw.layer.cornerRadius = 10.0
        vw.layer.shadowRadius = 5.0
        vw.layer.shadowOpacity = 0.5
        vw.layer.shouldRasterize = true
        vw.layer.rasterizationScale = UIScreen.main.scale
        vw.backgroundColor = .systemGray5
        
        return vw
    }()
    
    private lazy var twoHStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .horizontal
        vw.alignment = .top
        vw.distribution = .equalSpacing
        
        return vw
    }()
    
    private lazy var threeVStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .vertical
        
        return vw
    }()
    
    private lazy var publicReposLabel: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Public Repos"
        lb.font = .preferredFont(forTextStyle: .headline).monospaced()
        
        return lb
    }()
    
    private lazy var reposValueLabel: UIView = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "50"
        lb.font = .preferredFont(forTextStyle: .subheadline).italic()
        
        return lb
    }()
    
    private lazy var fourVStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .vertical
        
        return vw
    }()
    
    private lazy var publicGistsLabel: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Public Gists"
        lb.font = .preferredFont(forTextStyle: .headline).monospaced()
        
        return lb
    }()
    
    private lazy var gistsValueLabel: UIView = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "100"
        lb.font = .preferredFont(forTextStyle: .subheadline).italic()
        
        return lb
    }()
    
    private lazy var fiveVStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .vertical
        
        return vw
    }()
    
    private lazy var profileSinceLabel: UILabel = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "Contribute Since"
        lb.font = .preferredFont(forTextStyle: .headline).monospaced()
        
        return lb
    }()
    
    private lazy var sinceValueLabel: UIView = {
        let lb = AppFactoryView.buildLabel()
        lb.text = "1974"
        lb.font = .preferredFont(forTextStyle: .subheadline).italic()
        
        return lb
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isHiddenActivityIndicator(true)
        }
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
    func setSearchTextFieldDelegate(_ delegate: UISearchTextFieldDelegate) -> Void {
        self.searchTextFieldDelegate = delegate
    }
    
    func isHiddenActivityIndicator(_ isHidden: Bool) -> Void {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut) { [weak self] in
            self?.blurEffectView.alpha = 0.0
            self?.activityIndicatorView.alpha = 0.0
        } completion: { _ in
            self.blurEffectView.isHidden = true
            self.activityIndicatorView.isHidden = true
        }
    }
    
    private func setupViews() -> Void {
        backgroundColor = .appSecondary
        
        addSubview(containerView)
        
        containerView.addSubview(blurEffectView)
        containerView.addSubview(activityIndicatorView)
        containerView.addSubview(oneVStackView)
        containerView.bringSubviewToFront(blurEffectView)
        containerView.bringSubviewToFront(activityIndicatorView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneVStackView.addArrangedSubview(searchTextField)
        oneVStackView.addArrangedSubview(profileImageView)
        oneVStackView.addArrangedSubview(twoVStackView)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.01, after: searchTextField)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.03, after: profileImageView)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.05, after: twoVStackView)
        oneVStackView.addArrangedSubview(containerDetailView)
        oneVStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.height * 0.05)
            make.horizontalEdges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.width * 0.95)
            make.height.equalTo(UIScreen.height * 0.35)
        }
        
        twoVStackView.addArrangedSubview(profileName)
        twoVStackView.setCustomSpacing(UIScreen.height * 0.01, after: profileName)
        twoVStackView.addArrangedSubview(profileUsername)
        twoVStackView.setCustomSpacing(UIScreen.height * 0.01, after: profileUsername)
        twoVStackView.addArrangedSubview(profileBio)
        twoVStackView.setCustomSpacing(UIScreen.height * 0.01, after: profileBio)
        twoVStackView.addArrangedSubview(oneHStackView)
        
        oneHStackView.addArrangedSubview(locationView)
        oneHStackView.setCustomSpacing(10.0, after: locationView)
        oneHStackView.addArrangedSubview(locationName)
        
        containerDetailView.addSubview(twoHStackView)
        containerDetailView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.width * 0.95)
            make.height.equalTo(UIScreen.height * 0.15)
        }
        
        twoHStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20.0)
        }
        
        twoHStackView.addArrangedSubview(threeVStackView)
        twoHStackView.addArrangedSubview(fourVStackView)
        twoHStackView.addArrangedSubview(fiveVStackView)
        
        threeVStackView.addArrangedSubview(publicReposLabel)
        threeVStackView.setCustomSpacing(10.0, after: publicReposLabel)
        threeVStackView.addArrangedSubview(reposValueLabel)
        
        fourVStackView.addArrangedSubview(publicGistsLabel)
        fourVStackView.setCustomSpacing(10.0, after: publicGistsLabel)
        fourVStackView.addArrangedSubview(gistsValueLabel)
        
        fiveVStackView.addArrangedSubview(profileSinceLabel)
        fiveVStackView.setCustomSpacing(10.0, after: profileSinceLabel)
        fiveVStackView.addArrangedSubview(sinceValueLabel)
        
    }

}

#if DEBUG
@available(iOS 13, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview(HomeView(frame: .zero))
    }
}
#endif

