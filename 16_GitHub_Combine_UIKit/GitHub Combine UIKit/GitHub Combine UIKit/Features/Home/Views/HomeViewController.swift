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
    @Published private var searchBarPublisher: String?
    private var searchBarSubscriber: AnyCancellable?
    
    private let homeViewModel = HomeViewModel()
    private let homeView = HomeView()
    
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
        
        setupSearchBarSubscriber()
    }
    
    private func setupViews() -> Void {
        homeView.setSearchBarDelegate(self)
        
        view = homeView
    }
    
    private func setupSearchBarSubscriber() -> Void {
        searchBarSubscriber = $searchBarPublisher
            .receive(on: DispatchQueue.main)
            .map { result -> String in
                guard let result else { return "" }
                return result
            }
            .sink { [weak self] result in
                self?.didTapSearchBar(result)
            }
    }
    
    private func didTapSearchBar(_ value: String) -> Void {
        if !value.isEmpty {
            let searchValue = value.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            homeViewModel.startGithubAPIProcess(username: searchValue)
            
            homeViewModel.startNetworkActivityProcess { [weak self] isInProgress in
                print("startApiNetworkProcess: ", isInProgress)
                
                self?.homeView.setIsHiddenActivityIndicator(isInProgress)
            }
            
            homeViewModel.startExtractGithubAPIUserProcess { user in
                print("startExtractGithubAPIUserProcess: ", user)
            }
            
            homeViewModel.startExtractProfileImageProcess { isInProgress, image in
                print("startExtractProfileImageProcess: ", isInProgress, String(describing: image))
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBarPublisher = searchBar.text
    }
}

#if DEBUG
@available(iOS 13, *)
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview(HomeViewController())
            .previewLayout(.sizeThatFits)
    }
}
#endif

