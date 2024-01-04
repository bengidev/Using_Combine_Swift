//
//  HomeViewController.swift
//  Simple Form
//
//  Created by Bambang Tri Rahmat Doni on 04/01/24.
//

import Combine
import SwiftUI
import UIKit

final class HomeViewController: UIViewController {
    // MARK: Properties
    private var oneTextFieldPublisher: AnyPublisher<String?, Never>?
    private var twoTextFieldPublisher: AnyPublisher<String?, Never>?
    private var cancellableSet: Set<AnyCancellable> = [] // 7
    
    private let homeView = HomeView()
    private let homeViewModel = HomeViewModel()

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
        
        oneTextFieldPublisher = homeViewModel.validateOneTextFieldValue { message in
            print("validateOneTextFieldValue: ", String(describing: message))
            self.homeView.setOneLabelText(with: message ?? "")
        }
        
        oneTextFieldPublisher?
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellableSet)
        
        twoTextFieldPublisher = homeViewModel.validateTwoTextFieldLabelValue { message in
            print("validateTwoTextFieldLabelValue: ", String(describing: message))
            self.homeView.setTwoLabelText(with: message ?? "")
        }
        
        twoTextFieldPublisher?
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellableSet)
        
        guard let oneTextFieldPublisher, let twoTextFieldPublisher else { return }
        homeViewModel.validateToSubmit(
            publisherOne: oneTextFieldPublisher,
            publisherTwo: twoTextFieldPublisher
        )
        .map { $0 != nil } // 8
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in self?.homeView.isEnabledOneButton(result) }
        .store(in: &cancellableSet) // 9
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
    
    private func didChangeOneTextField(_ value: String?) -> Void { // 1
        print("didChangeOneTextField: ", String(describing: value))
        
        homeViewModel.setOneTextFieldValue(with: value ?? "")
    }
    
    private func didChangeTwoTextField(_ value: String?) -> Void { // 1
        print("didChangeTwoTextField: ", String(describing: value))
        
        homeViewModel.setTwoTextFieldValue(with: value ?? "")
    }
    
    private func didChangeTwoMirrorTextField(_ value: String?) -> Void { // 1
        print("didChangeTwoMirrorTextField: ", String(describing: value))
        
        homeViewModel.setTwoMirrorTextFieldValue(with: value ?? "")
    }
    
    private func didTapOneButton() -> Void {
        print("Tester")
    }
}

/// 1. The start of this code follows the same patterns laid out in Declarative UI updates from user input. 
///     IBAction messages are used to update the @Published properties,
///     triggering updates to any subscribers attached.
/// 2. The first validation pipeline uses a map operator to take the string value input and convert it to nil
///     if it doesn’t match the validation rules. This is also converting the output type from
///     the published property of <String> to the optional <String?>. The same logic is also used
///     to trigger updates to the messages label to provide information about what is required.
/// 3. Since we are updating user interface elements, we explicitly make those updates wrapped
///     in DispatchQueue.main.async to invoke on the main thread.
/// 4. combineLatest takes two publishers and merges them into a single pipeline with an output type
///     that is the combined values of each of the upstream publishers. In this case, the output type
///     is a tuple of (<String>, <String>).
/// 5. Rather than use DispatchQueue.main.async, we can use the receive operator to explicitly run
///     the next operator on the main thread, since it will be doing UI updates.
/// 6. The two validation pipelines are combined with combineLatest, and the output of those checked and
///     merged into a single tuple output.
/// 7. We could store the assignment pipeline as an AnyCancellable? reference (to map it to the life
///     of the viewcontroller) but another option is to create something to collect all the cancellable references.
///     This starts as an empty set, and any sinks or assignment subscribers can be added to it
///     to keep a reference to them so that they operate over the full lifetime of the view controller.
///     If you are creating a number of pipelines, this can be a convenient way to maintain references to all of them.
/// 8. If any of the values are nil, the map operator returns nil down the pipeline. Checking against a nil value
///     provides the boolean used to enable (or disable) the submission button.
/// 9. the store method is available on the Cancellable protocol, which is explicitly set up to support
///     saving off references that can be used to cancel a pipeline.
///


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
