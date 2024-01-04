//
//  HomeViewController.swift
//  Simple Publisher Wrapper
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import UIKit

final class HomeViewController: UIViewController {

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
        navigationController?.navigationBar.topItem?.title = "Simple Publisher Wrapper"
        
        view.backgroundColor = .systemGray6
    }
}

