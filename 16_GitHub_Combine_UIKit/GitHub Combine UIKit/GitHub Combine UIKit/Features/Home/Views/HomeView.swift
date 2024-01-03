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
    // MARK: View Components
    private lazy var containerView: UIView = {
        let vw = AppFactoryView.buildView()
        
        return vw
    }()
    
    private lazy var oneVStackView: UIStackView = {
        let vw = AppFactoryView.buildStackView()
        vw.axis = .vertical

        return vw
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
    
    private func setupViews() -> Void {
        backgroundColor = .appSecondary
        
        addSubview(containerView)
        
        containerView.addSubview(oneVStackView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        oneVStackView.addArrangedSubview(profileImageView)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.03, after: profileImageView)
        oneVStackView.addArrangedSubview(twoVStackView)
        oneVStackView.setCustomSpacing(UIScreen.height * 0.05, after: twoVStackView)
        oneVStackView.addArrangedSubview(containerDetailView)
        oneVStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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

