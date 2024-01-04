//
//  HomeViewController.swift
//  Simple Form
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
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
    }
    
    // MARK: Functionalities
    private func setupViews() -> Void {
        navigationController?.navigationBar.topItem?.title = "Simple Form"
        
        homeView.setOneTextFieldHandler(action: didChangeOneTextField(_:))
        homeView.setTwoTextFieldHandler(action: didChangeTwoTextField(_:))
        homeView.setTwoMirrorTextFieldHandler(action: didChangeTwoMirrorTextField(_:))
        homeView.setOneButtonHandler(action: didTapOneButton)
        view = homeView
    }
    
    private func didChangeOneTextField(_ value: String?) -> Void {
        print("didChangeOneTextField: ", String(describing: value))
    }
    
    private func didChangeTwoTextField(_ value: String?) -> Void {
        print("didChangeTwoTextField: ", String(describing: value))
    }
    
    private func didChangeTwoMirrorTextField(_ value: String?) -> Void {
        print("didChangeTwoMirrorTextField: ", String(describing: value))
    }
    
    private func didTapOneButton() -> Void {
        print("Tester")
    }
}

#if DEBUG
@available(iOS 13, *)
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        NavigationControllerPreview(barStyle: .largeTitle, showsToolbar: true) {
            HomeViewController()
        }
    }
}
#endif
