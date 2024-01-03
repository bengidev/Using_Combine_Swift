//
//  HomeViewController.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 03/01/24.
//

import Combine
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
    private var profileImageValue: AnyCancellable?
    private var nameValue: AnyCancellable?
    private var usernameValue: AnyCancellable?
    private var bioValue: AnyCancellable?
    private var locationValue: AnyCancellable?
    private var reposTotalValue: AnyCancellable?
    private var gistsTotalValue: AnyCancellable?
    private var sinceValue: AnyCancellable?
    
    private let homeView: UIView = HomeView()
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("awakeFromNib() has not been implemented")
    }
    
    // MARK: Lifecycles
    override func loadView() {
        super.loadView()
        
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    private func setupViews() -> Void {
        navigationController?.navigationBar.topItem?.title = "GitHub Combine"
        
        view = homeView
    }
}

#if DEBUG
@available(iOS 13, *)
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        NavigationControllerPreview(barStyle: .largeTitle, showsToolbar: true) {
            HomeViewController()
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif

